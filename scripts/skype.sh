#!/bin/bash
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
	return 1
}

main() {
	return 0
}
