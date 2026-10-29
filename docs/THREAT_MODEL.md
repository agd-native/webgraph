# Threat model

## Protected assets

- local files and credentials;
- private, loopback, link-local, metadata, and internal network services;
- host memory, CPU, process count, and worker integrity;
- MCP caller expectations about freshness and external side effects.

## Untrusted inputs

URLs, redirects, DNS answers, response headers and bodies, compressed data, HTML, JavaScript,
semantic attributes, MCP arguments, and worker IPC are untrusted.

## Enforced controls

- fail-closed URL and address validation with transport address pinning;
- bounded redirects, body sizes, decompression ratio, DOM size, output, IPC, and diffs;
- stale document/node checks;
- read-only action policy by default;
- separate worker process with timeout and platform resource controls;
- worker executable identity verification around launch.

## Known non-goals and residual risks

- no pixel/layout/canvas interpretation;
- no CAPTCHA or anti-bot bypass;
- no complete Chromium-compatible JavaScript or browser API surface;
- no AppContainer, seccomp, network namespace, or per-domain egress allowlist;
- Linux worker containment has not yet received the same physical acceptance evidence as Windows;
- enabling experimental actions increases the risk of external side effects and requires caller-side
  confirmation and independent observation.
