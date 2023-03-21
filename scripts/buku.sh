#!/bin/bash

usage() {
	echo -n "personal mini-web in text"
	# shellcheck disable=2016,2028
	echo '
 _           _
| |__  _   _| | ___   _
| |_ \| | | | |/ / | | |
| |_) | |_| |   <| |_| |
|_.__/ \__,_|_|\_\\__,_|
	'
}

export dependencies=('python')

main_pacman() {
	return 0
}

main() {
	require_pip buku
}

main_parham() {
	msg "hello parham, clone your bookmarks private repository"

	if [ ! -d "$HOME/Documents/Git/parham/parham-alvani" ]; then
		mkdir "$HOME/Documents/Git/parham/parham-alvani"
	fi

	cd "$HOME/Documents/Git/parham/parham-alvani" || return
	clone parham-alvani/tabs git@github.com:
	cd - || return

	cd "$HOME/Documents/Git/parham/parham-alvani/tabs" || return
	mkdir -p "$HOME/.local/share/buku" && linker "buku" "$(pwd)/bookmarks.db" "$_/bookmarks.db"
	cd - || return
}
