# Release readiness

This document records evidence for the `0.1.0-beta.1` public candidate. A green
build is not a security certification or proof of production fitness.

## Verified on Windows and hosted Ubuntu

Run on 2026-10-27 with the locked dependency graph:

- `cargo fmt --all -- --check`: PASS
- `cargo test --lib --locked`: PASS (47 tests)
- `cargo test --test web_security_suite --locked`: PASS (7 tests)
- `cargo test --test web_worker_suite --locked`: PASS (13 tests)
- `cargo clippy --all-targets --locked -- -D warnings`: PASS
- `cargo build --release --bins --locked`: PASS
- AGD structural rules: PASS (0 findings)
- AGD documentation drift: PASS (0 stale sections)

GitHub Actions run 40649388497 reproduced the locked CI gate on both
`windows-latest` and `ubuntu-latest`: PASS (2/2 jobs). The standalone public
repository has one root commit and no matches from the repository's bounded
key/token/path signature scan.

The release workflow additionally requires the Git tag to exactly match the
Cargo package version, rebuilds and retests both platforms, packages both
binaries together, generates SHA-256 files, and keeps the GitHub Release in
draft state until all matrix jobs pass.

## Published beta evidence

The `v0.1.0-beta.1` tag points to commit `9ba373e`. GitHub Actions release run
40651116859 completed successfully on 2026-10-28 and published two archives
plus their SHA-256 files:

- Windows x64 ZIP: 9,241,617 bytes, SHA-256
  `47ebbd418a472edfccf64843dc21c56f5654ab23184270f74b81efbe9c8b666b`;
- Linux x86_64 tar.gz: 9,019,211 bytes, SHA-256
  `ce6ab303e0f5505aabfd1d99dcfa72082fc151839047b0a14ccba95232519012`.

Post-publication installer smoke tests downloaded the public assets, verified
their checksum files, installed both neighboring binaries, and confirmed that
`agd-webgraph` starts and exits cleanly when its stdio input reaches EOF. This
passed on Windows and WSL Ubuntu. Smoke directories were removed afterward.

An independent remote Linux host acceptance then exercised the published
archive on an Ubuntu x86_64 host with a Linux 5.15 kernel. It verified MCP
`initialize`, the five-tool read-only surface, dynamic execution through the
separate worker, live HTTPS retrieval, and the physical `/proc` process state.
The worker had matching 268,435,456-byte soft and hard `RLIMIT_AS` values,
reported `unix_rlimit_as`, and was reaped after an infinite-loop timeout. The
temporary installation and test script were removed in a separate verification
step; unrelated host services remained active.

## Dependency metadata

`cargo metadata --locked --format-version 1` resolved 208 packages including
the workspace package. Every external package supplied a non-empty SPDX-style
license field. This is an inventory check, not legal compatibility review.

## Not yet verified

- Live internet battle suite: `NOT_RUN` in the deterministic post-commit gate;
  it is intentionally excluded because it depends on external services.
- Vulnerability database audit: `NOT_RUN_TOOL_UNAVAILABLE` (`cargo-audit` is not
  installed in the preparation environment).
- Dedicated secret scanner: `NOT_RUN_TOOL_UNAVAILABLE` (`gitleaks` and
  `trufflehog` are not installed). The bounded repository scan is not a
  substitute for either tool.
- SBOM generation: `NOT_RUN_TOOL_UNAVAILABLE` (`cargo-cyclonedx` and `syft` are
  not installed).
- Independent penetration test and third-party security review: `NOT_RUN`.

## Reproduction

From the repository root, execute the locked commands above. The worker tests
exercise process identity pinning, timeout termination, crash classification,
IPC limits, state invalidation, and OS resource limits. The live battle suite
can be run separately with:

```text
cargo test --test web_battle_suite --locked
```

Record the commit, operating system, Rust version, exact command status, and
binary SHA-256 values with release artifacts. Do not upgrade a `NOT_RUN` or
`ENV_BLOCKED` item to `PASS` based on CI configuration alone.
