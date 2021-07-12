#!/bin/bash

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

cat >"$HOME/.xinitrc" <<EOF
# start herbstluftwm in locked mode (it will be unlocked at the end of your
# autostart)
exec herbstluftwm --locked
EOF

sudo systemctl enable lightdm

# cd "$HOME/yay" && makepkg -si
# cd "$HOME/dotfiles/" && ./start.sh herbstluftwm
