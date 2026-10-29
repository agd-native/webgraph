# Security policy

## Supported versions

Only the latest tagged beta is supported while the public API and sandbox boundary are stabilizing.

## Reporting a vulnerability

Do not publish exploitable details in a public issue. Until a dedicated security mailbox is
configured, open a minimal issue requesting a private reporting channel without including the
payload, target URL, credentials, or reproduction details.

Reports should include the affected version and platform, expected security boundary, smallest safe
reproduction, and whether the issue can reach local files, private networks, credentials, arbitrary
code execution, or external side effects.

## Security boundary

Read-only policy, URL validation, resource quotas, and the worker process reduce risk; they do not
turn WebGraph into a complete browser sandbox. AppContainer, seccomp, a network namespace, and a
domain allowlist are not currently enforced. See `docs/THREAT_MODEL.md`.
