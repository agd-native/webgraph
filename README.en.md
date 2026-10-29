# AGD WebGraph

**English** | [Русский](README.md)

[![Release](https://img.shields.io/github/v/release/agd-native/webgraph)](https://github.com/agd-native/webgraph/releases/latest)
[![License: MIT OR Apache-2.0](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue.svg)](LICENSE-MIT)

AGD WebGraph is a compact semantic web runtime for AI agents. It converts HTML and bounded
client-side state into a graph exposed through MCP, avoiding screenshots and visual rendering when
page semantics are sufficient.

## Install

### Linux x86_64

```sh
curl -fsSL https://raw.githubusercontent.com/agd-native/webgraph/main/install.sh | sh
```

The default destination is `~/.local/bin`. To select another directory and version:

```sh
curl -fsSL https://raw.githubusercontent.com/agd-native/webgraph/main/install.sh | \
  AGD_WEBGRAPH_INSTALL_DIR="$HOME/opt/agd-webgraph" sh -s -- v0.1.0-beta.1
```

### Windows x64

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/agd-native/webgraph/main/install.ps1 -OutFile install.ps1
.\install.ps1
```

The default destination is `%LOCALAPPDATA%\Programs\AGD-WebGraph`. The installer does not modify
`PATH`. Archives and separate SHA-256 files are available from
[Releases](https://github.com/agd-native/webgraph/releases/latest).

## Connect an MCP client

`agd-webgraph` is a background stdio server without a separate window. An MCP client starts the
process and exchanges JSON-RPC through stdin/stdout.

Linux:

```json
{
  "mcpServers": {
    "agd-webgraph": {
      "command": "/home/USER/.local/bin/agd-webgraph"
    }
  }
}
```

Windows:

```json
{
  "mcpServers": {
    "agd-webgraph": {
      "command": "C:\\Users\\USER\\AppData\\Local\\Programs\\AGD-WebGraph\\agd-webgraph.exe"
    }
  }
}
```

Call `web_capabilities` first, then `web_open`. The server also exposes `web_extract`, `web_diff`,
and `web_explain`. The mutating `web_act` tool is experimental and only appears with the
`--experimental-web-actions` argument.

## Current limitations

- the beta supports Windows x64 and Linux x86_64;
- WebGraph is not a Chromium replacement and does not handle layout, canvas, CAPTCHA, or browser
  extensions;
- JavaScript runs in a separate constrained process, but this is not yet a complete browser
  sandbox;
- Linux uses `RLIMIT_AS`; seccomp, a network namespace, and subprocess blocking are not yet
  enforced;
- mutating actions are disabled by default.

Read the [security policy](SECURITY.md), [threat model](docs/THREAT_MODEL.md), and
[release readiness evidence](docs/RELEASE_READINESS.md) before exposing the process to untrusted
clients.

## License

Version `v0.1.0-beta.1` is licensed under either Apache License 2.0 or MIT License, at your option.
