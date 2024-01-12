#!/usr/bin/env bash
set -e

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/message.sh
source "$tmuxs_root/../../scripts/lib/message.sh"
# shellcheck source=./scripts/lib/require.sh
source "$tmuxs_root/../../scripts/lib/require.sh"

not_require_country 'Iran'
