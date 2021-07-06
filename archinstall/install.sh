#!/bin/bash

systemctl enable lightdm

su -s parham

cd "$HOME/yay" && makepkg -si
cd "$HOME/dotfiles/" && ./start.sh i3
