/**
 * hide-footer: start with an empty footer; `/footer` toggles the default back.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	let hidden = true;

	const apply = (ctx: { ui: { setFooter: (f?: unknown) => void } }) => {
		if (hidden) {
			ctx.ui.setFooter((_tui: unknown, _theme: unknown) => ({
				invalidate() {},
				render(_width: number): string[] {
					return [];
				},
			}));
		} else {
			ctx.ui.setFooter(undefined);
		}
	};

	pi.on("session_start", async (_event, ctx) => {
		if (hidden) apply(ctx);
	});

	pi.registerCommand("footer", {
		description: "Toggle footer visibility",
		handler: async (_args, ctx) => {
			hidden = !hidden;
			apply(ctx);
			ctx.ui.notify(hidden ? "Footer hidden" : "Default footer shown", "info");
		},
	});
}
