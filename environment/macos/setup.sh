#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "This setup script must be run on macOS." >&2
    exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required. Install it from https://brew.sh/ and rerun this script." >&2
    exit 1
fi

packages_file="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/packages/macos-packages.txt"
awk '!/^#/ && NF { print }' "$packages_file" | xargs -r brew install

echo "Portable macOS packages installed. Run environment/validate.sh to verify the toolchain."
echo "Linux-specific IPC and kernel exercises must be run in the course VM or Cloud Shell."


# MacOS
brew update && brew install --cask gcloud-cli

# Than run
gcloud init
