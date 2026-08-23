/**
 * session-cleanup: audit + manage pi sessions for the current directory.
 *
 * Deterministic modes:
 *   /session-cleanup                        — static rule-based report
 *   /session-cleanup rename <id-prefix> <new-name>
 *   /session-cleanup delete <id-prefix>     — moves to sessions/.trash
 *
 * Agent mode ("janitor"):
 *   /session-cleanup ask [instruction…]
 *     Spawns a headless `pi -p` that reads a fact-sheet manifest and
 *     produces a one-line-per-session PLAN. You review, optionally give
 *     feedback, it revises; on approval the extension executes the safe
 *     actions itself (rename/delete-to-trash). The agent never acts
 *     directly — no tools, no write access.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

interface SessionInfo {
	file: string;
	id: string;
	name?: string;
	cwd: string;
	sizeBytes: number;
	entries: number;
	lastActivity: Date;
	firstPrompt: string;
	lastOutput: string;
	parent?: string;
}

function fmtSize(n: number): string {
	return n > 1024 * 1024 ? `${(n / 1048576).toFixed(1)}M` : `${Math.round(n / 1024)}K`;
}
function ageDays(d: Date): number {
	return (Date.now() - d.getTime()) / 86_400_000;
}

function loadSessions(cwd: string): SessionInfo[] {
	const root = path.join(os.homedir(), ".pi", "agent", "sessions");
	const out: SessionInfo[] = [];
	if (!fs.existsSync(root)) return out;

	for (const proj of fs.readdirSync(root)) {
		const pdir = path.join(root, proj);
		if (!fs.statSync(pdir).isDirectory()) continue;
		for (const f of fs.readdirSync(pdir)) {
			if (!f.endsWith(".jsonl")) continue;
			const file = path.join(pdir, f);
			try {
				const stat = fs.statSync(file);
				const lines = fs.readFileSync(file, "utf-8").split("\n").filter(Boolean);
				if (!lines.length) continue;
				const header = JSON.parse(lines[0]);
				if (header.type !== "session") continue;
				if (path.resolve(header.cwd || "") !== path.resolve(cwd)) continue;

				let name: string | undefined;
				let firstPrompt = "";
				let lastOutput = "";
				for (const l of lines) {
					let e: any;
					try {
						e = JSON.parse(l);
					} catch {
						continue;
					}
					if (e.type === "session_info" && e.name) name = e.name;
					if (e.type === "message") {
						const m = e.message;
						const c = Array.isArray(m?.content) ? m.content : [];
						const t = c.find((x: any) => x.type === "text");
						if (!t?.text) continue;
						const txt = String(t.text).replace(/\s+/g, " ").trim();
						if (m.role === "user" && !firstPrompt) firstPrompt = txt;
						if (m.role === "assistant" && txt) lastOutput = txt;
					}
				}
				out.push({
					file,
					id: header.id || f.replace(/\.jsonl$/, ""),
					name,
					cwd: header.cwd,
					sizeBytes: stat.size,
					entries: lines.length,
					lastActivity: stat.mtime,
					firstPrompt,
					lastOutput,
					parent: header.parentSession,
				});
			} catch {
				// unreadable — skip
			}
		}
	}
	return out;
}

function buildManifest(sessions: SessionInfo[], selfPath?: string): string {
	const rows = sessions.map((x) => {
		const flags = [
			x.file === selfPath ? "CURRENT(do not touch)" : null,
			x.parent ? "clone" : null,
			x.name ? `name:"${x.name}"` : "UNNAMED",
		]
			.filter(Boolean)
			.join(",");
		return (
			`${x.id.slice(0, 8)} | ${flags} | ${fmtSize(x.sizeBytes)} | ` +
			`idle ${Math.floor(ageDays(x.lastActivity))}d | ${x.entries} entries\n` +
			`    first: ${x.firstPrompt.slice(0, 80) || "(none)"}\n` +
			`    last-out: ${x.lastOutput.slice(0, 80) || "(none)"}`
		);
	});
	return rows.join("\n");
}

const JANITOR_SYSTEM = `You are a strict, conservative session janitor for the pi coding agent.

You will receive a manifest of session files. Produce a cleanup PLAN.

Output format — EXACTLY one line per session, nothing else:
<id8> | KEEP | <short reason>
<id8> | DELETE | <short reason>
<id8> | RENAME:<new-name> | <short reason>
<id8> | COMPACT | <short reason>

Rules:
- NEVER propose an action for sessions marked CURRENT(do not touch); always KEEP them.
- DELETE only for: unnamed throwaways, stale clones whose work clearly landed elsewhere, junk like "test".
- When in doubt: KEEP. A wrong DELETE loses work forever; a wrong KEEP costs nothing.
- RENAME unnamed sessions that look worth keeping; names should be short, lowercase, descriptive.
- COMPACT for large sessions that look active/valuable.
- Reasons must be under 60 chars.`;

interface PlanLine {
	id8: string;
	action: "KEEP" | "DELETE" | "RENAME" | "COMPACT";
	arg?: string;
	reason: string;
	raw: string;
}

function parsePlan(text: string): PlanLine[] {
	const out: PlanLine[] = [];
	for (const line of text.split("\n")) {
		const m = line.trim().match(/^([0-9a-f]{8})\s*\|\s*(KEEP|DELETE|COMPACT|RENAME[:\s]*([^\s|]+))?\s*\|\s*(.+)$/i);
		if (!m) continue;
		const actionRaw = (m[2] || "KEEP").toUpperCase();
		let action: PlanLine["action"] = "KEEP";
		let arg: string | undefined;
		if (actionRaw.startsWith("DELETE")) action = "DELETE";
		else if (actionRaw.startsWith("COMPACT")) action = "COMPACT";
		else if (actionRaw.startsWith("RENAME")) {
			action = "RENAME";
			arg = (m[3] || "").replace(/["']/g, "");
		}
		out.push({ id8: m[1], action, arg, reason: m[4].slice(0, 70), raw: line.trim() });
	}
	return out;
}

/**
 * Resolve how to launch a headless pi: relaunch ourselves — node + this
 * process's own entry script (process.argv[1]). Same version, same
 * everything. No other fallbacks: if this fails, the command errors.
 */
function resolvePiInvocation(): string[] | null {
	const self = process.argv[1] || "";
	if (
		self.endsWith(".js") &&
		fs.existsSync(self) &&
		(self.includes("pi-coding-agent") || self.endsWith("cli.js"))
	) {
		return [process.execPath, self];
	}
	return null;
}

function runJanitor(
	manifest: string,
	extra: string,
	modelArg: string | undefined,
): Promise<string> {
	const tmp = path.join(os.tmpdir(), `janitor-sys-${Date.now()}.txt`);
	fs.writeFileSync(tmp, JANITOR_SYSTEM);
	const args = [
		"-p",
		"--no-session",
		"--tools",
		"none",
		"--append-system-prompt",
		tmp,
		// Mechanical classification — don't let it deliberate.
		"--thinking",
		"low",
	];
	if (modelArg) args.push("--model", modelArg);
	args.push(
		`SESSION MANIFEST:\n${manifest}\n\n${extra ? `USER INSTRUCTION: ${extra}\n` : ""}` +
			`Produce the plan now, one line per session.`,
	);
	const invocation = resolvePiInvocation();
	if (!invocation) {
		return Promise.reject(
			new Error("cannot resolve pi entry script (process.argv[1] not a pi CLI)"),
		);
	}
	const TIMEOUT_MS = 600_000;
	return new Promise((resolve, reject) => {
		execFile(
			invocation[0],
			[...invocation.slice(1), ...args],
			{ timeout: TIMEOUT_MS, maxBuffer: 1024 * 1024, stdio: ["ignore", "pipe", "pipe"] },
			(err, stdout, stderr) => {
				fs.unlinkSync(tmp);
				if (err && !stdout) {
					const why = (err as NodeJS.ErrnoException & { killed?: boolean; signal?: string })
						.killed
						? `timed out after ${TIMEOUT_MS / 1000}s (provider congestion?)`
						: stderr || err.message;
					return reject(new Error(`${why} (tried: ${invocation.join(" ")})`));
				}
				resolve(stdout);
			},
		);
	});
}

function renderPlan(plan: PlanLine[], sessions: SessionInfo[]): string[] {
	const badge = (a: PlanLine["action"]) =>
		a === "DELETE" ? "\x1b[31mDEL \x1b[0m" : a === "RENAME" ? "\x1b[33mREN \x1b[0m" : a === "COMPACT" ? "\x1b[36mCMP \x1b[0m" : "\x1b[32mKEEP\x1b[0m";
	const lines: string[] = ["JANITOR PLAN — one line per session", ""];
	for (const p of plan) {
		const s = sessions.find((x) => x.id.startsWith(p.id8));
		const label = s?.name ? `"${s.name}"` : "(unnamed)";
		lines.push(`${badge(p.action)} ${p.id8} ${label}${p.arg ? ` → "${p.arg}"` : ""}`);
		lines.push(`      ${p.reason}`);
	}
	lines.push("");
	lines.push("Enter feedback to revise (e.g. \"keep e6212d58\"), or empty to execute.");
	return lines;
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("session-cleanup", {
		description:
			"Manage sessions for this dir. /session-cleanup [ask [instruction]] | rename <id> <name> | delete <id>",
		handler: async (args, ctx) => {
			const parts = (args || "").trim().split(/\s+/).filter(Boolean);
			const verb = parts[0];
			const sessions = loadSessions(ctx.cwd);

			if (!verb) {
				ctx.ui.notify(
					`${sessions.length} session(s) here. Try: /session-cleanup ask — the janitor will propose a plan.`,
					"info",
				);
				return;
			}

			// ---------- janitor mode ----------
			if (verb === "ask") {
				if (sessions.length < 3) {
					ctx.ui.notify(`Only ${sessions.length} session(s) here — nothing to manage.`, "info");
					return;
				}
				const selfPath = ctx.sessionManager.getSessionFile();
				const modelArg = ctx.model ? `${ctx.model.provider}/${ctx.model.id}` : undefined;

				let extra = parts.slice(1).join(" ");
				let plan: PlanLine[] = [];

				for (let round = 0; round < 3; round++) {
					ctx.ui.notify(round === 0 ? "Consulting the janitor…" : "Revising plan…", "info");
					let raw: string;
					try {
						raw = await runJanitor(buildManifest(sessions, selfPath), extra, modelArg);
					} catch (e) {
						ctx.ui.notify(
							`Janitor failed: ${(e as Error).message}. Could not resolve a launchable pi entry — set PI_BIN as a workaround.`,
							"error",
						);
						return;
					}
					plan = parsePlan(raw).filter((p) =>
						sessions.some((s) => s.id.startsWith(p.id8)),
					);
					if (!plan.length) {
						ctx.ui.notify("Janitor returned an unparseable plan.", "error");
						return;
					}

					// Show plan, ask for feedback/approval.
					const planText = renderPlan(plan, sessions).join("\n");
					const feedback = await ctx.ui.custom<string | null>(
						(tui, theme, _kb, done) => ({
							invalidate() {},
							render(width: number): string[] {
								const out: string[] = [];
								for (const rawLine of planText.split("\n")) {
									for (let i = 0; i < rawLine.length; i += width)
										out.push(rawLine.slice(i, i + width));
								}
								return out;
							},
							handleInput() {}, // input goes to the embedded editor below
						}),
						{ overlay: true, overlayOptions: { width: "90%", maxHeight: "70%", anchor: "top-center" } },
					);
					void feedback;

					const adjustment = await ctx.ui.input(
						"Approve: enter nothing. Or tell the janitor what to change:",
					);
					if (adjustment === null) return; // esc — abort entirely
					if (!adjustment.trim()) break; // approved

					extra = `Previous plan:\n${plan.map((p) => p.raw).join("\n")}\n\nUser says: ${adjustment.trim()}\nRevise the plan accordingly.`;
				}

				// ---------- execute approved plan ----------
				let done = 0;
				for (const p of plan) {
					const target = sessions.find((s) => s.id.startsWith(p.id8));
					if (!target || target.file === selfPath) continue;
					try {
						if (p.action === "DELETE") {
							const trash = path.join(path.dirname(target.file), ".trash");
							fs.mkdirSync(trash, { recursive: true });
							fs.renameSync(target.file, path.join(trash, path.basename(target.file)));
							done++;
						} else if (p.action === "RENAME" && p.arg) {
							fs.appendFileSync(
								target.file,
								JSON.stringify({ type: "session_info", name: p.arg, timestamp: Date.now() }) + "\n",
							);
							done++;
						} else if (p.action === "COMPACT") {
							ctx.ui.notify(
								`COMPACT ${target.id.slice(0, 8)} manually: pi --session ${target.file}, then /compact`,
								"info",
							);
						}
					} catch (e) {
						ctx.ui.notify(`${p.action} ${p.id8} failed: ${(e as Error).message}`, "error");
					}
				}
				ctx.ui.notify(
					`Janitor done: ${done} action(s) applied, ${plan.filter((p) => p.action === "KEEP").length} kept.`,
					"info",
				);
				return;
			}

			// ---------- rename / delete ----------
			if ((verb === "rename" || verb === "delete") && sessions.length > 0) {
				const prefix = parts[1] || "";
				const matches = sessions.filter(
					(x) => x.id.startsWith(prefix) || path.basename(x.file).startsWith(prefix),
				);
				if (matches.length !== 1) {
					ctx.ui.notify(`session-cleanup: ${matches.length} match(es) for "${prefix}"`, "error");
					return;
				}
				const target = matches[0];

				if (verb === "rename") {
					const newName = parts.slice(2).join(" ").trim();
					if (!newName) {
						ctx.ui.notify("Usage: /session-cleanup rename <id-prefix> <new-name>", "error");
						return;
					}
					fs.appendFileSync(
						target.file,
						JSON.stringify({ type: "session_info", name: newName, timestamp: Date.now() }) + "\n",
					);
					ctx.ui.notify(`Renamed ${target.id.slice(0, 8)} → "${newName}"`, "info");
					return;
				}

				if (verb === "delete") {
					if (target.file === ctx.sessionManager.getSessionFile()) {
						ctx.ui.notify("Refusing to delete the session you're in.", "error");
						return;
					}
					const trash = path.join(path.dirname(target.file), ".trash");
					fs.mkdirSync(trash, { recursive: true });
					fs.renameSync(target.file, path.join(trash, path.basename(target.file)));
					ctx.ui.notify(`Moved ${target.id.slice(0, 8)} (${target.name || "unnamed"}) → .trash/`, "info");
					return;
				}
			}

			ctx.ui.notify(
				"Usage: /session-cleanup ask [instruction] | rename <id-prefix> <name> | delete <id-prefix>",
				"error",
			);
		},
	});
}
