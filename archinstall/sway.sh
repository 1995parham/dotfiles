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

# global variable that points to dotfiles root directory
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp "$current_dir/sway.d/sway.sh" /usr/local/bin/sway.sh
sudo cp "$current_dir/sway.d/sway.desktop" /usr/share/wayland-sessions/sway.desktop

cd "$HOME/yay-bin" && makepkg -si

#echo "have fun with your i3"
#cd "$HOME/dotfiles/" && ./start.sh i3
sudo pacman -Syu firefox
