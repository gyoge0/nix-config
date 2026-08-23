/**
 * pi-status: keep the terminal title/status bar truthful + notify on idle.
 *
 * - Working  → title shows "pi: working…" while an agent run is active
 * - Idle     → title flips to "pi: idle", plus a rich notification
 *              (cmux native `cmux notify --surface` when available,
 *               raw OSC 9 fallback otherwise)
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import * as fs from "node:fs";

export default function (pi: ExtensionAPI) {
	const base = () => `pi`;

	pi.on("agent_start", async (_event, ctx) => {
		if (ctx.hasUI) ctx.ui.setTitle(`${base()}: working…`);
	});

	// Also cover turns that start without a fresh run event (e.g. queued follow-ups).
	pi.on("turn_start", async (_event, ctx) => {
		if (ctx.hasUI) ctx.ui.setTitle(`${base()}: working…`);
	});

	pi.on("agent_settled", async (_event, ctx) => {
		if (ctx.hasUI) ctx.ui.setTitle(`${base()}: idle`);

		// Extract last assistant text — never send an empty body.
		let summary = "finished (no assistant output)";
		try {
			const entries = ctx.sessionManager.getEntries();
			for (let i = entries.length - 1; i >= 0; i--) {
				const msg = (entries[i] as { message?: { role?: string; content?: unknown } })
					.message;
				if (msg?.role === "assistant") {
					const content = msg.content as
						| Array<{ type: string; text?: string }>
						| undefined;
					const text = content?.find((c) => c.type === "text")?.text ?? "";
					if (text.trim()) {
						summary = text.replace(/\s+/g, " ").trim();
						break;
					}
				}
			}
		} catch {
			// keep default
		}

		const body = summary.length > 200 ? summary.slice(0, 197) + "…" : summary;
		const label =
			ctx.sessionManager.getSessionName() || ctx.cwd.split("/").pop() || "pi";

		const surface = process.env.CMUX_SURFACE_ID;
		if (surface) {
			execFile(
				"cmux",
				[
					"notify",
					"--surface",
					surface,
					"--title",
					`${base()} (${label}): waiting for you`,
					"--body",
					body,
				],
				{ timeout: 5000 },
				(err) => {
					if (err) osc9(body);
				},
			);
		} else {
			osc9(body);
		}
	});
}

function osc9(body: string) {
	try {
		const fd = fs.openSync("/dev/tty", "w");
		fs.writeSync(fd, `\x1b]2;pi: idle\x07`); // set window title too
		fs.writeSync(fd, `\x1b]9;pi: waiting for you\x07`);
		fs.writeSync(fd, `\x1b]9;${body.replace(/[\x00-\x1f\x07]/g, " ")}\x07`);
		fs.closeSync(fd);
	} catch {
		// no controlling tty
	}
}
