#!/bin/bash

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

echo "install mesa-vdpau for better performance on ATI graphic cards"
echo "https://wiki.archlinux.org/title/Improving_performance"

sudo systemctl enable lightdm

cd "$HOME/yay-bin" && makepkg -si

read -r -p "do you want the minimal installation?[Y/n] " -n 1 accept
echo
if [[ $accept == "Y" ]]; then
	echo "i3 minimal installation"
	cd "$HOME/dotfiles/" && ./start.sh mini3
	sudo pacman -Syu netsurf
else
	echo "i3 full installation"
	cd "$HOME/dotfiles/" && ./start.sh i3
	sudo pacman -Syu firefox
fi
