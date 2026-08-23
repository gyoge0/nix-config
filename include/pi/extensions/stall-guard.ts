/**
 * stall-guard: auto-recover from stalled LLM streams.
 *
 * Wraps globalThis.fetch for streaming chat/completions requests. If no
 * chunk arrives within `STALL_TIMEOUT_MS` (before or mid-stream), the
 * request is aborted and retried with a fresh HTTP request — automating
 * the manual "cancel + resend" workaround for congested providers
 * (e.g. free OpenRouter stealth endpoints).
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STALL_TIMEOUT_MS = 60_000; // max silence between chunks
const FIRST_BYTE_TIMEOUT_MS = 120_000; // max wait before first byte (big uncached prefills)
const MAX_RETRIES = 3;

export default function (_pi: ExtensionAPI) {
	const origFetch = globalThis.fetch.bind(globalThis);

	globalThis.fetch = async function guardedFetch(
		input: Parameters<typeof fetch>[0],
		init?: Parameters<typeof fetch>[1],
	): Promise<Response> {
		const url =
			typeof input === "string"
				? input
				: input instanceof URL
					? input.href
					: input.url;

		const isChatStream =
			url.includes("/chat/completions") &&
			typeof init?.body === "string" &&
			init.body.includes('"stream":true');

		if (!isChatStream) return origFetch(input, init);

		let retries = 0;

		const attempt = (): Promise<Response> =>
			new Promise<Response>((resolve, reject) => {
				const controller = new AbortController();
				const outerSignal = init?.signal;
				if (outerSignal) {
					if (outerSignal.aborted) return controller.abort();
					outerSignal.addEventListener("abort", () => controller.abort(), { once: true });
				}

				origFetch(input, { ...init, signal: controller.signal })
					.then((response) => {
						if (!response.body || !response.ok) {
							resolve(response); // let pi handle errors normally
							return;
						}

						const reader = response.body.getReader();
						const chunks: ReadableStreamReadResult<Uint8Array>[] = [];
						let firstChunkAt: number | null = null;
						let settled = false;

						const armTimer = () =>
							setTimeout(
								() => {
									if (settled) return;
									settled = true;
									reader.cancel().catch(() => {});
									controller.abort();
									reject(
										new Error(
											firstChunkAt === null
												? `stall-guard: no response data after ${FIRST_BYTE_TIMEOUT_MS / 1000}s`
												: `stall-guard: stream stalled ${STALL_TIMEOUT_MS / 1000}s without activity`,
										),
									);
								},
								firstChunkAt === null ? FIRST_BYTE_TIMEOUT_MS : STALL_TIMEOUT_MS,
							);

						let timer = armTimer();

						const pump = () => {
							reader
								.read()
								.then((chunk) => {
									clearTimeout(timer);
									if (settled) return;
									if (firstChunkAt === null) firstChunkAt = Date.now();
									chunks.push(chunk);
									if (chunk.done) {
										settled = true;
										resolve(
											new Response(
												new ReadableStream<Uint8Array>({
													start(c) {
														for (const ch of chunks)
															if (!ch.done && ch.value) c.enqueue(ch.value);
														c.close();
													},
												}),
												{
													status: response.status,
													statusText: response.statusText,
													headers: response.headers,
												},
											),
										);
										return;
									}
									timer = armTimer();
									pump();
								})
								.catch((err) => {
									clearTimeout(timer);
									if (!settled) {
										settled = true;
										reject(err);
									}
								});
						};
						pump();
					})
					.catch(reject);
			});

		const run = async (): Promise<Response> => {
			while (true) {
				try {
					return await attempt();
				} catch (err) {
					const msg = err instanceof Error ? err.message : String(err);
					if (msg.startsWith("stall-guard:") && retries < MAX_RETRIES) {
						retries++;
						console.error(`[stall-guard] ${msg} — retrying (${retries}/${MAX_RETRIES})`);
						continue;
					}
					throw err;
				}
			}
		};

		return run();
	} as typeof fetch;
}
