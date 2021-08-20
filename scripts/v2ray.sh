#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : v2ray.sh
#
# [] Creation Date : 31-07-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "v2ray for u.s. unfair sanctions"

	# shellcheck disable=1004,2016
	echo '
       ____
__   _|___ \ _ __ __ _ _   _
\ \ / / __) | |__/ _| | | | |
 \ V / / __/| | | (_| | |_| |
  \_/ |_____|_|  \__,_|\__, |
                       |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm v2ray
}

main_brew() {
	brew install v2ray
	brew services start v2ray
}

main() {
	current_dir=${current_dir:?"current_dir must be set"}

	sudo cp "$current_dir/ghermezi/config.json" /etc/v2ray/config.json
}
