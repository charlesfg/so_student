#!/usr/bin/env bash

set -u

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <c-program> <bash-reference>" >&2
    exit 2
fi

PROGRAM="$1"
REFERENCE="$2"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXPECTED_OUTPUT="$(mktemp)"
ACTUAL_OUTPUT="$(mktemp)"
ERROR_OUTPUT="$(mktemp)"
trap 'rm -f "$EXPECTED_OUTPUT" "$ACTUAL_OUTPUT" "$ERROR_OUTPUT"' EXIT

fail() {
    echo "FAIL: $1" >&2
    exit 1
}

compare_case() {
    local name="$1"
    local input="$2"
    shift 2

    "$REFERENCE" "$ROOT/data/$input" "$@" > "$EXPECTED_OUTPUT" || \
        fail "$name: reference implementation failed"
    "$PROGRAM" "$ROOT/data/$input" "$@" > "$ACTUAL_OUTPUT" || \
        fail "$name: C implementation failed"

    diff -u "$EXPECTED_OUTPUT" "$ACTUAL_OUTPUT" || \
        fail "$name: outputs differ"
}

expect_failure() {
    local name="$1"
    shift

    if "$@" > "$ACTUAL_OUTPUT" 2> "$ERROR_OUTPUT"; then
        fail "$name: command unexpectedly succeeded"
    fi
    if [ -s "$ACTUAL_OUTPUT" ]; then
        fail "$name: command wrote data to stdout"
    fi
}

compare_case "sample default top-n" sample.txt
diff -u "$ROOT/data/expected_sample.csv" "$EXPECTED_OUTPUT" || \
    fail "sample default top-n: reference output is incorrect"

compare_case "sample top-n 3" sample.txt 3
compare_case "case and punctuation" case_punctuation.txt
diff -u "$ROOT/data/expected_case_punctuation.csv" "$EXPECTED_OUTPUT" || \
    fail "case and punctuation: reference output is incorrect"

compare_case "empty file" empty.txt
diff -u "$ROOT/data/expected_empty.csv" "$EXPECTED_OUTPUT" || \
    fail "empty file: reference output is incorrect"

compare_case "top-n 1" sample.txt 1

expect_failure "C invalid top-n" "$PROGRAM" "$ROOT/data/sample.txt" 0
expect_failure "Bash invalid top-n" "$REFERENCE" "$ROOT/data/sample.txt" 0
expect_failure "C missing argument" "$PROGRAM"
expect_failure "Bash missing argument" "$REFERENCE"
expect_failure "C missing file" "$PROGRAM" "$ROOT/data/missing.txt"
expect_failure "Bash missing file" "$REFERENCE" "$ROOT/data/missing.txt"

echo "all tests passed"
