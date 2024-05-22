#!/usr/bin/env bash

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

export dependencies=('python' 'rust')

main_pacman() {
	require_pip buku
	require_aur bukubrow
}

main_brew() {
	require_brew buku
}

main() {
	return 0
}

main_parham() {
	msg "hello parham, clone your bookmarks private repository"

	clone git@github.com:parham-alvani/tabs "$HOME/Documents/Git/parham/parham-alvani"

	cd "$HOME/Documents/Git/parham/parham-alvani/tabs" || return
	mkdir -p "$HOME/.local/share/buku" && linker "buku" "$(pwd)/bookmarks.db" "$_/bookmarks.db"
	cd - || return
}
