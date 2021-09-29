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
	curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh >install-release.sh
	chmod +x install-release.sh
	sudo ./install-release.sh
	rm install-release.sh

	current_dir=${current_dir:?"current_dir must be set"}

	sudo cp "$current_dir/ghermezi/config.json" /usr/local/etc/v2ray/config.json
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm v2ray

	current_dir=${current_dir:?"current_dir must be set"}

	sudo cp "$current_dir/ghermezi/config.json" /etc/v2ray/config.json
}

main_brew() {
	brew install v2ray
	brew services start v2ray

	current_dir=${current_dir:?"current_dir must be set"}

	sudo cp "$current_dir/ghermezi/config.json" /usr/local/etc/v2ray/config.json
}
