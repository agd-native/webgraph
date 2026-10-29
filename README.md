# AGD WebGraph

[English](README.en.md) | **Русский**

[![Release](https://img.shields.io/github/v/release/agd-native/webgraph)](https://github.com/agd-native/webgraph/releases/latest)
[![Лицензия: MIT OR Apache-2.0](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue.svg)](LICENSE-MIT)

AGD WebGraph — компактная семантическая web-среда для ИИ-агентов. Она преобразует HTML и
ограниченное клиентское состояние в граф и предоставляет его через MCP без скриншотов и
визуального рендеринга, когда агенту достаточно смысла страницы.

## Установка

### Linux x86_64

```sh
curl -fsSL https://raw.githubusercontent.com/agd-native/webgraph/main/install.sh | sh
```

Файлы устанавливаются в `~/.local/bin`. Другой каталог и версию можно выбрать так:

```sh
curl -fsSL https://raw.githubusercontent.com/agd-native/webgraph/main/install.sh | \
  AGD_WEBGRAPH_INSTALL_DIR="$HOME/opt/agd-webgraph" sh -s -- v0.1.0-beta.1
```

### Windows x64

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/agd-native/webgraph/main/install.ps1 -OutFile install.ps1
.\install.ps1
```

По умолчанию файлы устанавливаются в `%LOCALAPPDATA%\Programs\AGD-WebGraph`. Установщик не меняет
`PATH`. Архивы и отдельные SHA-256 доступны в [Releases](https://github.com/agd-native/webgraph/releases/latest).

## Подключение к MCP

`agd-webgraph` — фоновый stdio-сервер без отдельного окна. MCP-клиент запускает его и обменивается
JSON-RPC через stdin/stdout.

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

После подключения сначала вызовите `web_capabilities`, затем `web_open`. Доступны также
`web_extract`, `web_diff` и `web_explain`. Изменяющий инструмент `web_act` является
экспериментальным и появляется только с аргументом `--experimental-web-actions`.

## Текущие ограничения

- beta поддерживает Windows x64 и Linux x86_64;
- WebGraph не заменяет Chromium и не обрабатывает layout, canvas, CAPTCHA и расширения;
- JavaScript выполняется в отдельном ограниченном процессе, но это ещё не полноценный browser
  sandbox;
- Linux использует `RLIMIT_AS`; seccomp, network namespace и запрет дочерних процессов пока не
  применяются;
- изменяющие действия по умолчанию отключены.

Перед подключением недоверенных клиентов прочитайте [security policy](SECURITY.md) и
[threat model](docs/THREAT_MODEL.md). Результаты release-проверок находятся в
[release readiness](docs/RELEASE_READINESS.md).

## Лицензия

Версия `v0.1.0-beta.1` распространяется по Apache License 2.0 или MIT License на выбор пользователя.
