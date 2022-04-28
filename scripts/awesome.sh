#!/bin/bash

usage() {
	echo -n -e "awesome projects to review them daily"

	# shellcheck disable=1004,2016
	echo '
  __ ___      _____  ___  ___  _ __ ___   ___
 / _| \ \ /\ / / _ \/ __|/ _ \| |_ | _ \ / _ \
| (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/
 \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___|

  '
}

from_github() {
	repo=$1

	path="$HOME/Documents/Git/awesome/${repo%/*}"
	mkdir -p "$path"
	cd "$path/" || return

	git clone "git@github.com:$repo" || true
}

main() {
	from_github avelino/awesome-go
	from_github rust-unofficial/awesome-rust
	from_github rust-embedded/awesome-embedded-rust
	from_github mpsq/arewewaylandyet
	from_github natpen/awesome-wayland
}
