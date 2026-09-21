#!/usr/bin/env bash

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="${EISVOGEL_TEMPLATE:-eisvogel.latex}"
PDF_ENGINE="${PDF_ENGINE:-lualatex}"

command -v pandoc >/dev/null 2>&1 || {
    echo "Error: pandoc is not installed or is not in PATH." >&2
    exit 1
}
command -v "$PDF_ENGINE" >/dev/null 2>&1 || {
    echo "Error: PDF engine '$PDF_ENGINE' is not installed or is not in PATH." >&2
    exit 1
}

# MiKTeX may otherwise wait for interactive package-installation input.
export MIKTEX_AUTOINSTALL="${MIKTEX_AUTOINSTALL:-no}"

cd "$ROOT"

PANDOC_ARGS=(
    guide/PL1.md
    --from gfm+alerts
    --template "$TEMPLATE"
    --lua-filter guide/alerts.lua
    --syntax-highlighting pygments
    --number-sections
    --resource-path ".:guide:data"
    -o guide/PL1.pdf
)

if ! pandoc "${PANDOC_ARGS[@]}" --pdf-engine "$PDF_ENGINE"; then
    if [ "$PDF_ENGINE" = "lualatex" ] && command -v xelatex >/dev/null 2>&1; then
        echo "Warning: lualatex failed; retrying with xelatex." >&2
        pandoc "${PANDOC_ARGS[@]}" --pdf-engine xelatex
    else
        exit 1
    fi
fi

echo "Generated $ROOT/guide/PL1.pdf"
