#!/usr/bin/env bash
# Do all of the steps: create the VM, upgrade it, and install the dotfiles.
# Usage: lima/scripts/up.sh [vm-name]
set -euo pipefail

here=$(dirname "${BASH_SOURCE[0]}")

"${here}/create.sh" "$@"
"${here}/upgrade.sh" "$@"
"${here}/dotfiles.sh" "$@"
