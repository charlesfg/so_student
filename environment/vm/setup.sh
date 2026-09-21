#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
packages_file="$repo_root/environment/packages/required-packages.txt"

if ! command -v apt-get >/dev/null 2>&1; then
    echo "This setup script requires apt-get on a Debian/Ubuntu-like VM." >&2
    exit 1
fi

if [[ "${EUID}" -eq 0 ]]; then
    apt-get update
    awk '!/^#/ && NF { print }' "$packages_file" | xargs -r apt-get install -y
else
    sudo apt-get update
    awk '!/^#/ && NF { print }' "$packages_file" | sudo xargs -r apt-get install -y
fi

echo "Required packages installed. Run environment/validate.sh to verify the VM."
