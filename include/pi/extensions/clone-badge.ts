/**
 * clone-badge: make it obvious when you're in a cloned/forked session.
 *
 * Clones carry `parentSession` in their session header. On startup we
 * check for it and pin a persistent status indicator, plus a one-time
 * notification. Works no matter how the clone was made (/clone,
 * pi --fork, or the piclone shell function).
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import * as path from "node:path";

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		try {
			const header = ctx.sessionManager.getHeader() as
				| { parentSession?: string; id?: string }
				| undefined;
			if (!header?.parentSession) return;

			const parentName = path.basename(header.parentSession).replace(/\.jsonl$/, "").slice(0, 12);
			const name = ctx.sessionManager.getSessionName?.();

			ctx.ui.setStatus("clone", `⎇ CLONE of …${parentName}${name ? ` (${name})` : ""}`);
			ctx.ui.notify(
				`This is a CLONE — it shares history with ${parentName} up to the split, but is now independent.`,
				"info",
			);
		} catch {
			// header unavailable (ephemeral session?) — nothing to show
		}
	});
}
