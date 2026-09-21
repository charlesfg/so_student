#!/usr/bin/env bash
set -euo pipefail

platform="$(uname -s)"
if [[ "$platform" == "Darwin" ]]; then
    required_commands=(clang gdb make git bash)
    compiler=clang
else
    required_commands=(gcc gdb make git bash)
    compiler=gcc
fi
missing=0

echo "Operating system: $(uname -srm)"
if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    echo "Distribution: ${PRETTY_NAME:-unknown}"
fi

for command_name in "${required_commands[@]}"; do
    if command -v "$command_name" >/dev/null 2>&1; then
        printf 'found %-5s %s\n' "$command_name" "$(command -v "$command_name")"
    else
        printf 'missing %s\n' "$command_name" >&2
        missing=1
    fi
done

for command_name in ps kill ipcs; do
    if command -v "$command_name" >/dev/null 2>&1; then
        printf 'found %-5s %s\n' "$command_name" "$(command -v "$command_name")"
    else
        printf 'note: %s is unavailable; IPC/process exercises may be limited\n' "$command_name"
    fi
done

if (( missing )); then
    echo "The baseline toolchain is incomplete." >&2
    exit 1
fi

validation_dir="$(mktemp -d "${TMPDIR:-/tmp}/so2027-validate.XXXXXX")"
trap 'rm -rf "$validation_dir"' EXIT

cat > "$validation_dir/validate.c" <<'EOF'
#include <pthread.h>
#include <sys/mman.h>

static void *worker(void *argument) { return argument; }

int main(void) {
    pthread_t thread;
    (void)mmap;
    if (pthread_create(&thread, NULL, worker, NULL) != 0) return 1;
    return pthread_join(thread, NULL) != 0;
}
EOF

"$compiler" -Wall -Wextra -g -pthread "$validation_dir/validate.c" -o "$validation_dir/validate"
"$validation_dir/validate"

if [[ "$platform" == "Linux" ]]; then
    cat > "$validation_dir/ipc.c" <<'EOF'
#include <semaphore.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <sys/shm.h>
int main(void) { return 0; }
EOF
    "$compiler" -Wall -Wextra -pedantic "$validation_dir/ipc.c" -o "$validation_dir/ipc"
    echo "Linux System V IPC headers compile successfully."
else
    echo "macOS mode: Linux-specific System V IPC and /proc facilities were not required."
fi

echo "Environment validation passed."
