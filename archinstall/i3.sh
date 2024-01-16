#!/bin/bash
set -e

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

# global variable that points to `dotfiles/archinstall` root directory
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/main.sh
source "$current_dir/../scripts/lib/main.sh"

# configure makepkg to use tlsv1.3 because we are in iran
cd "$current_dir/.." && ./start.sh pacman

# install yay to have yay for installing from
cd "$current_dir/.." && ./start.sh yay

# install required packages using pacman and yay
cd "$current_dir/.." && ./start.sh env

sudo systemctl enable lightdm

echo "have fun with your i3"
cd "$current_dir/.." && ./start.sh i3
