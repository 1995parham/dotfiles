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

	if [[ "$USER" == "parham" ]]; then
		msg "hello parham, clone your private repositories"

		if [ ! -d "$HOME/Documents/Git/parham/parham-alvani/tabs" ]; then
			mkdir "$HOME/Documents/Git/parham/parham-alvani" || true
			git clone git@github.com:parham-alvani/tabs "$HOME/Documents/Git/parham/parham-alvani/tabs"
			cd "$HOME/Documents/Git/parham/parham-alvani/tabs" || return
			mkdir -p "$HOME/.local/share/buku" && ln -s "$(pwd)/bookmarks.db" "$_/bookmarks.db"
			cd - || return
		fi
	fi
}
