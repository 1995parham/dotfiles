#!/bin/bash

usage() {
	echo -n "Robust, fast, intuitive plain text accounting tool with CLI, TUI and web interfaces."
	# shellcheck disable=2016,2028
	echo '
 _     _          _
| |__ | | ___  __| | __ _  ___ _ __
| |_ \| |/ _ \/ _| |/ _| |/ _ \ |__|
| | | | |  __/ (_| | (_| |  __/ |
|_| |_|_|\___|\__,_|\__, |\___|_|
                    |___/
	'
}

main_pacman() {
	require_pacman hledger
}

main() {
	return 0
}

main_parham() {
	msg "hello parham, clone your accounting private repository"

	clone git@github.com:parham-alvani/ledger "$HOME/Documents/Git/parham/parham-alvani"

	cd "$HOME/Documents/Git/parham/parham-alvani/ledger" || return
	linker "hledger" "$(pwd)/2023.journal" "$HOME/.hledger.journal"
	cd - || return
}
