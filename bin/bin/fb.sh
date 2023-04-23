#!/bin/bash

set -eu

# find and open bookmarks using buku

# save newline separated string into an array
mapfile -t website <<<"$(buku -p -f 4 | column -t -s $'\t' -E2 | fzf --multi)"

# open each website
for i in "${website[@]}"; do
	index="$(echo "$i" | awk '{print $1}')"
	buku -p "$index"
	buku -o "$index"
done
