#!/usr/bin/env bash
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
	require_brew_cask gpg-suite-nightly
	msg 'set gpg suite to be auto started'
	osascript -e 'tell application "System Events" to ¬' \
		-e 'make new login item with properties ¬' \
		-e '{name:"GPG Keychain", path:"/Applications/GPG Keychain.app", hidden:true}'
}

main() {
	return 0
}

main_parham() {
	return 0
}
