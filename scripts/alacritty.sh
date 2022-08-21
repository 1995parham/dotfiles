#!/bin/bash

usage() {
	echo -n "alacritty terminal with jetbrains mono font and configuration"
	# shellcheck disable=2016
	echo '
       _                 _ _   _
  __ _| | __ _  ___ _ __(_) |_| |_ _   _
 / _` | |/ _` |/ __| |__| | __| __| | | |
| (_| | | (_| | (__| |  | | |_| |_| |_| |
 \__,_|_|\__,_|\___|_|  |_|\__|\__|\__, |
                                   |___/
	'
}

export dependencies=('rust')

main_brew() {
	brew install --cask alacritty
}

main_pacman() {
	require_aur alacritty-git
}

main() {
	configfile alacritty
}
