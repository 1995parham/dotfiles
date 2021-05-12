#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "navi cheatsheet"
	echo '
                   _
 _ __   __ ___   _(_)
| |_ \ / _` \ \ / / |
| | | | (_| |\ V /| |
|_| |_|\__,_| \_/ |_|
  '
}

main_brew() {
	brew install navi
}

main_apt() {
	if [ ! -f /usr/local/bin/navi ]; then
		sudo BIN_DIR=/usr/local/bin bash -c "$(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)"
	fi
}

main_pacman() {
	yay -Syu --noconfirm --needed navi-bin
}

main() {
	user=1995parham
	repo=cheats
	git clone "https://github.com/${user}/${repo}" "$(navi info cheats-path)/${user}__${repo}" || true
}
