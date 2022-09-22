#!/bin/bash

usage() {
	echo "usage: mpv"
	echo '
 _ __ ___  _ ____   __
| |_ ` _ \| |_ \ \ / /
| | | | | | |_) \ V /
|_| |_| |_| .__/ \_/
          |_|
  '
}

main_brew() {
	brew install --cask mpv
}

main_pacman() {
	# require_aur mpv-git
	require_pacman mpv
}

main() {
	configfile mpv
}
