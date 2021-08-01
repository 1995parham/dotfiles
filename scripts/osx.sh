#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : i3.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "apple osx"
	# shellcheck disable=1004
	echo '
  ___  _____  __
 / _ \/ __\ \/ /
| (_) \__ \>  <
 \___/|___/_/\_\

  '
}

main_pacman() {
	return 1
}

main_apt() {
	return 1
}

main_brew() {
	current_dir=${current_dir:?"current_dir must be set"}

	msg 'osx keyring'
	brew install pinentry-mac
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$current_dir/osx/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}
