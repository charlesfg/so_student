#!/usr/bin/env bash

# PL1 starter: complete the pipeline after the validation below.
set -u

usage() {
    echo "Usage: $0 <input-file> [top-n]" >&2
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    usage
    exit 1
fi

INPUT_FILE="$1"
TOP_N=10

if [ "$#" -eq 2 ]; then
    TOP_N="$2"
fi

if [ ! -f "$INPUT_FILE" ] || [ ! -r "$INPUT_FILE" ]; then
    echo "Error: input file is not a readable regular file: $INPUT_FILE" >&2
    exit 1
fi

if [[ ! "$TOP_N" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: top-n must be a positive integer: $TOP_N" >&2
    exit 1
fi

export LC_ALL=C
printf 'word,count\n'

# TODO: replace this placeholder with the pipeline from guide/PL1.md.
# The pipeline must write only CSV data to stdout and use TOP_N.
echo "TODO: complete the word-count pipeline" >&2
exit 2
