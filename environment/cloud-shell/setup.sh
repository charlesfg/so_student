#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
packages_file="$repo_root/environment/packages/required-packages.txt"
bootstrap_file="$repo_root/environment/cloud-shell/customize_environment"

if ! command -v apt-get >/dev/null 2>&1; then
    echo "This setup script requires apt-get in Google Cloud Shell." >&2
    exit 1
fi

sudo apt-get update
awk '!/^#/ && NF { print }' "$packages_file" | sudo xargs -r apt-get install -y

install -m 0755 "$bootstrap_file" "$HOME/.customize_environment"

echo "Required packages installed."
echo "Persistent Cloud Shell bootstrap installed at \$HOME/.customize_environment."
echo "Run environment/validate.sh to verify the environment."
