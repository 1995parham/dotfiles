#!/bin/bash

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

sudo systemctl enable lightdm

cd "$HOME/yay-bin" && makepkg -si
cd "$HOME/dotfiles/" && ./start.sh i3
