#!/bin/sh
set -eu

REPOSITORY="agd-native/webgraph"
INSTALL_DIR="${AGD_WEBGRAPH_INSTALL_DIR:-${HOME}/.local/bin}"
VERSION="${AGD_WEBGRAPH_VERSION:-${1:-}}"

case "$(uname -s)" in
    Linux) ;;
    *)
        echo "AGD WebGraph installer currently supports Linux only." >&2
        exit 1
        ;;
esac

case "$(uname -m)" in
    x86_64|amd64) TARGET="x86_64-unknown-linux-gnu" ;;
    *)
        echo "Unsupported architecture: $(uname -m). Only Linux x86_64 is published in this beta." >&2
        exit 1
        ;;
esac

for command in curl tar sha256sum install; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "Required command is missing: $command" >&2
        exit 1
    fi
done

if [ -z "$VERSION" ]; then
    VERSION="$(
        curl -fsSL -o /dev/null -w '%{url_effective}' \
            "https://github.com/${REPOSITORY}/releases/latest"
    )"
    VERSION="${VERSION##*/}"
fi

case "$VERSION" in
    v*) ;;
    *) VERSION="v${VERSION}" ;;
esac

ARCHIVE="agd-webgraph-${VERSION}-${TARGET}.tar.gz"
BASE_URL="https://github.com/${REPOSITORY}/releases/download/${VERSION}"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT HUP INT TERM

echo "Downloading AGD WebGraph ${VERSION} for ${TARGET}..."
curl -fL --retry 3 --proto '=https' --tlsv1.2 \
    -o "${TEMP_DIR}/${ARCHIVE}" "${BASE_URL}/${ARCHIVE}"
curl -fL --retry 3 --proto '=https' --tlsv1.2 \
    -o "${TEMP_DIR}/${ARCHIVE}.sha256" "${BASE_URL}/${ARCHIVE}.sha256"

(
    cd "$TEMP_DIR"
    sha256sum -c "${ARCHIVE}.sha256"
    tar -xzf "$ARCHIVE"
)

mkdir -p "$INSTALL_DIR"
install -m 0755 "${TEMP_DIR}/agd-webgraph" "${INSTALL_DIR}/agd-webgraph"
install -m 0755 "${TEMP_DIR}/agd-web-worker" "${INSTALL_DIR}/agd-web-worker"

echo "Installed AGD WebGraph ${VERSION} to ${INSTALL_DIR}"
case ":${PATH}:" in
    *":${INSTALL_DIR}:"*) ;;
    *) echo "Add ${INSTALL_DIR} to PATH, or use the absolute path in your MCP configuration." ;;
esac
echo "MCP command: ${INSTALL_DIR}/agd-webgraph"
