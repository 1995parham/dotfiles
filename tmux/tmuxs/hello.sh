#!/usr/bin/env bash

set -e

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/main.sh
source "$tmuxs_root/../../scripts/lib/main.sh"

# use a local version for yes_or_no because of the tmuxp design.
function _yes_or_no() {
	while true; do
		echo -e "\033[38;5;226m[hello] ${F_ORANGE}$*${F_RESET} [${F_GREEN}y${F_RESET}/${F_RED}n${F_RESET}]: "
		read -r -p "" yn
		case ${yn} in
		[Yy]*) return 0 ;;
		[Nn]*)
			echo -e "${F_YELLOW}Aborted${F_RESET}"
			return 1
			;;
		*) ;;
		esac
	done
}

if ! not_require_country 'Iran'; then
	if ! _yes_or_no 'hello' 'do you want to continue?'; then
		exit 1
	fi
fi
