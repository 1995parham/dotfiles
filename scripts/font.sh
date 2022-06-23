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
	sudo pacman -Syu --needed --noconfirm noto-fonts-emoji ttf-roboto ttf-jetbrains-mono ttf-font-awesome ttf-dejavu noto-fonts otf-font-awesome ttf-liberation
	yay -Syu --needed vazirmatn-fonts
	yay -Syu --needed vazir-code-fonts
	yay -Syu --needed nerd-fonts-jetbrains-mono
}

main_apt() {
	msg 'sorry we cannot do anything right now'

	return 1
}
