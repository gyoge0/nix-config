/**
 * clone-out: clone the current session WITHOUT switching to it.
 *
 * Writes a new session file that is a byte-for-byte copy of the current
 * session (header rewritten: new id, fresh timestamp, parentSession set
 * so clone-badge marks it), named (required), then prints the exact
 * `pi --session …` command to open it in another shell.
 *
 * Usage: /clone-out <name>
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { randomUUID } from "node:crypto";
import * as fs from "node:fs";
import * as path from "node:path";

export default function (pi: ExtensionAPI) {
	pi.registerCommand("clone-out", {
		description:
			"Clone this session to a new file without switching. Prints the resume command.",
		handler: async (args, ctx) => {
			const name = args?.trim();
			if (!name) {
				const current =
					ctx.sessionManager.getSessionName?.() || path.basename(ctx.sessionManager.getSessionFile() || "unnamed");
				ctx.ui.notify(
					`Usage: /clone-out <name> — a name is required (current session: "${current}")`,
					"error",
				);
				return;
			}

			const src = ctx.sessionManager.getSessionFile();
			if (!src || !fs.existsSync(src)) {
				ctx.ui.notify("clone-out: no persisted session (ephemeral?)", "error");
				return;
			}

			const dir = path.dirname(src);

			// Mirror pi's own session-file naming: ISO timestamp + uuid.
			const now = new Date();
			const stamp = now
				.toISOString()
				.replace(/[-:]/g, "-")
				.replace(/\./g, "-")
				.replace("Z", "");
			const id = randomUUID();
			const dst = path.join(dir, `${stamp}_${id}.jsonl`);

			const lines = fs.readFileSync(src, "utf-8").split("\n");

			// Rewrite header: new identity, keep cwd, record lineage.
			let header: Record<string, unknown> = {};
			try {
				header = JSON.parse(lines[0]);
			} catch {
				ctx.ui.notify("clone-out: unreadable session header", "error");
				return;
			}
			header.id = id;
			header.timestamp = now.toISOString().replace("Z", "Z");
			if (!header.cwd) header.cwd = ctx.cwd;
			header.parentSession = src;
			lines[0] = JSON.stringify(header);

			// Bake the name directly into the clone.
			lines.push(JSON.stringify({ type: "session_info", name, timestamp: Date.now() }));

			fs.writeFileSync(dst, lines.join("\n"));

			ctx.ui.notify(
				`Cloned to ${path.basename(dst)} as "${name}" — staying here.`,
				"info",
			);

			// Print the resume command; also persist it in this session's log.
			const cmd = `pi --session ${dst}`;
			ctx.ui.notify(`Run in another shell:\n${cmd}`, "info");
			pi.appendEntry?.("clone-out", { command: cmd });
		},
	});
}
