#!/bin/bash

usage() {
	echo -n -e "awesome projects to review them daily without internet"

	# shellcheck disable=1004,2016
	echo '
  __ ___      _____  ___  ___  _ __ ___   ___
 / _| \ \ /\ / / _ \/ __|/ _ \| |_ | _ \ / _ \
| (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/
 \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___|

  '
}

main_brew() {
	return 0
}

main_pacman() {
	return 0
}

main_apt() {
	return 0
}

from_github() {
	repo=$1

	msg "clone $repo"

	path="$HOME/Documents/Git/awesome/${repo%/*}"
	mkdir -p "$path"
	cd "$path/" || return

	git clone "git@github.com:$repo" 2>/dev/null || (cd "${repo#*/}" && git pull)
}

main() {
	from_github avelino/awesome-go
	from_github rust-unofficial/awesome-rust
	from_github rust-embedded/awesome-embedded-rust
	from_github mpsq/arewewaylandyet
	from_github natpen/awesome-wayland
	from_github rockerBOO/awesome-neovim
	from_github mzlogin/awesome-adb
}
