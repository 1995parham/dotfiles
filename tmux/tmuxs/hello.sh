#!/usr/bin/env bash

set -e

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/main.sh
source "$tmuxs_root/../../scripts/lib/main.sh"

if ! not_require_country 'Iran'; then
	if ! yes_or_no 'do you want to continue?'; then
		exit 1
	fi
fi
