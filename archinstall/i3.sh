#!/bin/bash
set -e

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

sudo systemctl enable lightdm

cd "$HOME/yay-bin" && makepkg -si

echo "have fun with your i3"
cd "$HOME/dotfiles/" && ./start.sh i3
