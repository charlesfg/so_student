#!/usr/bin/env bash

set -u

DOCUMENT_TOOLS=0
if [ "${1:-}" = "--documents" ]; then
    DOCUMENT_TOOLS=1
elif [ "$#" -ne 0 ]; then
    echo "Usage: $0 [--documents]" >&2
    exit 2
fi

REQUIRED_TOOLS="bash tr sort uniq head sed awk make cc"
DOCUMENT_TOOLS_LIST="pandoc lualatex marp pdftoppm"
missing=0

check_tool() {
    local tool="$1"
    if command -v "$tool" >/dev/null 2>&1; then
        printf '[OK]      %-10s %s\n' "$tool" "$(command -v "$tool")"
    else
        printf '[MISSING] %-10s\n' "$tool"
        missing=1
    fi
}

echo "PL1 environment validation"
echo "Required for the practical class:"
for tool in $REQUIRED_TOOLS; do
    check_tool "$tool"
done

if [ "$DOCUMENT_TOOLS" -eq 1 ]; then
    echo "Document-generation tools:"
    for tool in $DOCUMENT_TOOLS_LIST; do
        check_tool "$tool"
    done
fi

if [ "$missing" -ne 0 ]; then
    printf '\nEnvironment validation failed.\n' >&2
    exit 1
fi

printf '\nEnvironment validation passed.\n'
