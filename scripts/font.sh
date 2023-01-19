#!/bin/bash

usage() {
	echo "fonts for terminal, subtitles and more"
	echo '
  __             _
 / _| ___  _ __ | |_
| |_ / _ \| |_ \| __|
|  _| (_) | | | | |_
|_|  \___/|_| |_|\__|

  '
}

main_brew() {
	brew install --cask homebrew/cask-fonts/font-jetbrains-mono
	brew install --cask homebrew/cask-fonts/font-jetbrains-mono-nerd-font
	brew install --cask font-vazirmatn
}

main_pacman() {
	require_pacman noto-fonts-emoji ttf-roboto ttf-jetbrains-mono ttf-font-awesome ttf-dejavu noto-fonts \
		otf-font-awesome ttf-liberation ttf-jetbrains-mono-nerd ttf-meslo-nerd
	require_aur vazirmatn-fonts
}
