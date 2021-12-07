#!/bin/bash

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

echo "install mesa-vdpau for better performance on ATI graphic cards"
echo "https://wiki.archlinux.org/title/Improving_performance"

sudo systemctl enable lightdm

cd "$HOME/yay-bin" && makepkg -si

echo "have fun with your i3"
cd "$HOME/dotfiles/" && ./start.sh i3
sudo pacman -Syu firefox
