#!/usr/bin/env bash

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

command -v marp >/dev/null 2>&1 || {
    echo "Error: marp is not installed or is not in PATH." >&2
    exit 1
}

cd "$ROOT"

marp slides/PL1.md \
    --pdf \
    --allow-local-files \
    --pdf-outlines \
    --theme slides/theme.css \
    -o slides/PL1.pdf

echo "Generated $ROOT/slides/PL1.pdf"
