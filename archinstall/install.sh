#!/bin/bash

systemctl enable lightdm

su -s parham

cd "$HOME/yay" && makepkg -si
