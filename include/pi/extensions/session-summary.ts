/**
 * summary: a compact re-orientation card for the CURRENT session.
 *
 * /summary — renders inline in the transcript (native entry renderer):
 *   - identity & clone lineage
 *   - footprint stats
 *   - a short LLM-written description of what this session is about
 *     (headless pi, thinking=low; deterministic fallback on failure)
 *   - where the session left off
 *
 * Budget: max 35 lines x 78 cols.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { Box, Text } from "@earendil-works/pi-tui";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

const WIDTH = 78;
const MAX_LINES = 35;

function fmtSize(n: number): string {
	return n > 1024 * 1024 ? `${(n / 1048576).toFixed(1)}M` : `${Math.round(n / 1024)}K`;
}
function fmtAge(d: Date): string {
	const m = Math.floor((Date.now() - d.getTime()) / 60000);
	if (m < 60) return `${m}m ago`;
	const h = Math.floor(m / 60);
	if (h < 24) return `${h}h ago`;
	return `${Math.floor(h / 24)}d ago`;
}
function trunc(s: string, n: number): string {
	return s.length > n ? s.slice(0, n - 1) + "…" : s;
}
function home(p: string): string {
	const h = os.homedir();
	return p.startsWith(h) ? "~" + p.slice(h.length) : p;
}

/** Relaunch ourselves headlessly: node + this process's entry script. */
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

function headlessPi(
	system: string,
	task: string,
	modelArg?: string,
	signal?: AbortSignal,
): Promise<string> {
	const invocation = resolvePiInvocation();
	if (!invocation)
		return Promise.reject(new Error("cannot resolve pi entry script"));
	const tmp = path.join(os.tmpdir(), `pi-sys-${Date.now()}.txt`);
	fs.writeFileSync(tmp, system);
	const args = [
		"-p",
		"--no-session",
		"--tools",
		"none",
		"--thinking",
		"low",
		"--append-system-prompt",
		tmp,
	];
	if (modelArg) args.push("--model", modelArg);
	args.push(task);
	return new Promise((resolve, reject) => {
		const child = execFile(
			invocation[0],
			[...invocation.slice(1), ...args],
			{ timeout: 45_000, maxBuffer: 1024 * 1024, stdio: ["ignore", "pipe", "pipe"] },
			(err, stdout, stderr) => {
				fs.unlinkSync(tmp);
				if (signal?.aborted)
					return reject(new Error("cancelled"));
				if (err && !stdout) {
					const e = err as NodeJS.ErrnoException & { killed?: boolean };
					const why = e.killed
						? "timed out after 45s (provider congestion?)"
						: stderr || e.message;
					return reject(new Error(why));
				}
				resolve(stdout);
			},
		);
		signal?.addEventListener(
			"abort",
			() => {
				child.kill("SIGTERM");
			},
			{ once: true },
		);
	});
}

interface SummaryData {
	lines: string[];
	builtAt: number;
}

export default function (pi: ExtensionAPI) {
	pi.registerEntryRenderer<SummaryData>("session-summary", (entry, _opts, theme) => {
		const data = entry.data ?? { lines: [], builtAt: Date.now() };
		const box = new Box(1, 0, (t) => theme.bg("customMessageBg", t));
		data.lines.slice(0, MAX_LINES).forEach((l) => {
			let color = "text";
			if (/^(session |⎇|↳)/.test(l)) color = "accent";
			else if (/^(tokens|started )/.test(l)) color = "dim";
			else if (/^about this session/.test(l)) color = "warning";
			else if (/^\s{2}/.test(l)) color = "muted";
			box.addChild(new Text(theme.fg(color as any, trunc(l, WIDTH)), 0, 0));
		});
		if (data.lines.length > MAX_LINES)
			box.addChild(
				new Text(theme.fg("dim", `… truncated (${data.lines.length} lines)`), 0, 0),
			);
		return box;
	});

	pi.registerCommand("summary", {
		description: "Short rundown of the current session (lineage, state, what it's about)",
		handler: async (_args, ctx) => {
			ctx.ui.setStatus("summary", "summary: consulting model… (esc to cancel)");
			const sm = ctx.sessionManager;
			let header: any = {};
			try {
				header = sm.getHeader();
			} catch {}

			const selfFile = sm.getSessionFile() || "";
			const entries = sm.getEntries();

			let firstTs: Date | undefined;
			let lastTs: Date | undefined;
			let sizeBytes = 0;
			try {
				sizeBytes = fs.statSync(selfFile).size;
			} catch {}
			let inTok = 0,
				outTok = 0,
				cacheRead = 0,
				cost = 0;
			const prompts: string[] = [];
			const assistantSnippets: string[] = [];
			let lastUser = "";
			let lastAssistant = "";
			for (const e of entries as any[]) {
				const ts = e.timestamp ? new Date(e.timestamp) : undefined;
				if (ts) {
					if (!firstTs) firstTs = ts;
					lastTs = ts;
				}
				if (e.type !== "message") continue;
				const m = e.message;
				if (m?.role === "assistant") {
					if (m.usage) {
						inTok += m.usage.input || 0;
						outTok += m.usage.output || 0;
						cacheRead += m.usage.cacheRead || 0;
						cost += m.usage.cost?.total || 0;
					}
					for (const c of m.content || []) {
						if (c.type === "text" && c.text.trim())
							lastAssistant = c.text.replace(/\s+/g, " ").trim();
					}
					if (lastAssistant) assistantSnippets.push(lastAssistant);
				} else if (m?.role === "user" && Array.isArray(m.content)) {
					for (const c of m.content) {
						if (c.type === "text" && c.text.trim()) {
							lastUser = c.text.replace(/\s+/g, " ").trim();
							prompts.push(lastUser);
						}
					}
				}
			}

			// --- lineage ---
			const lineage: string[] = [];
			const parent = header.parentSession as string | undefined;
			if (parent) {
				const pname = path.basename(parent).replace(/\.jsonl$/, "").slice(0, 12);
				lineage.push(
					`⎇ clone of …${pname} (${fs.existsSync(parent) ? "parent on disk" : "parent gone"})`,
				);
			}
			let kids = 0;
			try {
				const root = path.join(os.homedir(), ".pi", "agent", "sessions");
				for (const proj of fs.readdirSync(root)) {
					const pdir = path.join(root, proj);
					if (!fs.statSync(pdir).isDirectory() || proj.startsWith(".")) continue;
					for (const f of fs.readdirSync(pdir)) {
						if (!f.endsWith(".jsonl")) continue;
						const fp = path.join(pdir, f);
						if (fp === selfFile) continue;
						try {
							const h = JSON.parse(fs.readFileSync(fp, "utf-8").split("\n")[0]);
							if (h.parentSession && path.resolve(h.parentSession) === path.resolve(selfFile))
								kids++;
						} catch {}
					}
				}
			} catch {}
			if (kids) lineage.push(`↳ ${kids} session(s) cloned from this one`);

			// --- ask a headless pi what this session is about ---
			let description = "";
			try {
				// Sample prompts across the whole arc, plus recent outcomes.
				const step = Math.max(1, Math.ceil(prompts.length / 8));
				const sampled = prompts.filter((_, i) => i % step === 0).slice(-8);
				const recentOut = assistantSnippets.slice(-3);
				const digest =
					`Session started ${firstTs?.toISOString() ?? "?"}, ${prompts.length} user prompts.\n` +
					`Prompts (sampled):\n${sampled.map((p) => `- ${p.slice(0, 150)}`).join("\n")}\n\n` +
					`Recent assistant outputs:\n${recentOut.map((o) => `- ${o.slice(0, 200)}`).join("\n")}`;
				description = await headlessPi(
					"You describe coding-agent sessions. Given a digest of a session's prompts and recent outputs, write WHAT THIS SESSION IS ABOUT: 1-3 short sentences, concrete (name the project/files/tools involved), no preamble, no markdown.",
					digest,
					ctx.model ? `${ctx.model.provider}/${ctx.model.id}` : undefined,
					ctx.signal,
				);
			description = description.replace(/```[\s\S]*?```/g, "").trim();
			} catch {
				description = "";
			} finally {
				ctx.ui.setStatus("summary", undefined);
			}
			if (!description)
				description = prompts.length
					? `(LLM unavailable) began with: ${trunc(prompts[0], WIDTH - 20)}`
					: "(empty session)";

			// --- compose ---
			const L: string[] = [];
			const name = sm.getSessionName() || "(unnamed)";
			L.push(`session "${name}" · ${header.id ? String(header.id).slice(0, 8) : "?"}`);
			L.push(`${home(ctx.cwd)} · ${ctx.model ? `${ctx.model.provider}/${ctx.model.id}` : "?"}`);
			L.push(
				`started ${firstTs ? fmtAge(firstTs) : "?"}, active ${lastTs ? fmtAge(lastTs) : "?"}` +
					` · ${fmtSize(sizeBytes)}, ${entries.length} entries`,
			);
			if (inTok || outTok)
				L.push(
					`tokens ↑${Math.round(inTok / 1000)}k ↓${(outTok / 1000).toFixed(1)}k` +
						` (cache read ${Math.round(cacheRead / 1000)}k)` +
						(cost ? ` · $${cost.toFixed(3)}` : ""),
				);
			if (lineage.length) L.push(...lineage);
			else L.push("(no fork history — original session)");
			L.push("");
			L.push("about this session:");
			for (const para of description.split("\n").filter(Boolean))
				for (let i = 0; i < para.length; i += WIDTH - 2)
					L.push(`  ${para.slice(i, i + WIDTH - 2)}`);
			L.push("");
			L.push("where it left off:");
			L.push(`  you: ${trunc(lastUser || "?", WIDTH - 6)}`);
			L.push(`  pi:  ${trunc(lastAssistant || "?", WIDTH - 6)}`);

			pi.appendEntry<SummaryData>("session-summary", { lines: L, builtAt: Date.now() });
		},
	});
}
