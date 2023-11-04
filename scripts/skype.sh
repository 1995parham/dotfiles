#!/usr/bin/env bash
usage() {
	echo "do your communication over skype because it is free and open"

	# shellcheck disable=1004,2016,2028
	echo '
     _
 ___| | ___   _ _ __   ___
/ __| |/ / | | | |_ \ / _ \
\__ \   <| |_| | |_) |  __/
|___/_|\_\\__, | .__/ \___|
          |___/|_|
  '
}

main_pacman() {
	require_aur skypeforlinux-preview-bin
}

main_apt() {
	return 1
}

main_brew() {
	require_brew_cask skype-preview
}

main() {
	return 0
}
