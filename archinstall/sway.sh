#!/bin/bash
set -e

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

echo "install mesa-vdpau for better performance on ATI graphic cards"
echo "https://wiki.archlinux.org/title/Improving_performance"

# echo "because of iran sanctions maybe you need ghermezi for downloading from github"
# cd "$HOME/dotfiles/" && ./start.sh v2ray
# sudo vim /etc/v2ray/config.json
# sudo systemctl enable --now v2ray

sudo systemctl enable sddm

cd "$HOME/yay-bin" && makepkg -si

#echo "have fun with your i3"
#cd "$HOME/dotfiles/" && ./start.sh i3
sudo pacman -Syu firefox
