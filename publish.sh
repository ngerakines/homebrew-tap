#!/usr/bin/env bash
set -euo pipefail

COLLECTION="garden.lexicon.exultant-zebra.distribution"
PLATFORMS=("darwin-arm64" "darwin-amd64" "linux-amd64" "linux-arm64")

usage() {
    echo "Usage: $0 <binary> <version> <directory>"
    echo
    echo "Upload binaries to a PDS and publish a distribution record."
    echo
    echo "Arguments:"
    echo "  binary     Binary name (e.g. atpcid, atpmcp, atpxrpc)"
    echo "  version    Version string (e.g. 0.14.0)"
    echo "  directory  Directory containing binaries named:"
    echo "               <binary>-darwin-arm64"
    echo "               <binary>-darwin-amd64"
    echo "               <binary>-linux-amd64"
    echo "               <binary>-linux-arm64"
    echo
    echo "Prerequisites:"
    echo "  - goat and jq must be installed"
    echo "  - Authenticate with: goat account login"
    exit 1
}

if [[ $# -ne 3 ]]; then
    usage
fi

BINARY="$1"
VERSION="$2"
DIR="$3"

if [[ ! -d "$DIR" ]]; then
    echo "Error: directory not found: $DIR" >&2
    exit 1
fi

for p in "${PLATFORMS[@]}"; do
    if [[ ! -f "$DIR/${BINARY}-${p}" ]]; then
        echo "Error: missing binary: $DIR/${BINARY}-${p}" >&2
        exit 1
    fi
done

for cmd in goat jq; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is not installed" >&2
        exit 1
    fi
done

ARTIFACTS="[]"

for p in "${PLATFORMS[@]}"; do
    IFS='-' read -r os arch <<< "$p"
    echo "Uploading ${BINARY}-${p}..."
    BLOB=$(goat blob upload "$DIR/${BINARY}-${p}")
    ARTIFACT=$(jq -n --argjson blob "$BLOB" --arg arch "$arch" --arg os "$os" \
        '{"tags": [$arch, $os], "download": $blob}')
    ARTIFACTS=$(echo "$ARTIFACTS" | jq --argjson a "$ARTIFACT" '. + [$a]')
done

RECORD=$(jq -n \
    --arg type "$COLLECTION" \
    --arg version "$VERSION" \
    --argjson artifacts "$ARTIFACTS" \
    '{"$type": $type, "version": $version, "artifacts": $artifacts}')

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT
echo "$RECORD" > "$TMPFILE"

echo
echo "Record:"
jq . "$TMPFILE"
echo

echo "Publishing record..."
goat record create --no-validate "$TMPFILE"
