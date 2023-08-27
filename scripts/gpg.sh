#!/bin/bash
usage() {
	echo "The GNU Privacy Guard"

	# shellcheck disable=1004,2016
	echo '

  __ _ _ __   __ _
 / _` | |_ \ / _` |
| (_| | |_) | (_| |
 \__, | .__/ \__, |
 |___/|_|    |___/
  '
}

root=${root:?"root must be set"}

main_pacman() {
	require_pacman gnupg rng-tools
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$root/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}

main_apt() {
	require_apt install gnupg2 git rng-tools
}

main_brew() {
	return 1
}

main() {
	return 0
}

main_parham() {
	return 0
}
