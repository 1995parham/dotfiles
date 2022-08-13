#!/bin/bash

function require_pacman() {
	for pkg in "$@"; do
		running "require" "pacman $pkg"
		if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
			action "require" "pacman -Sy $pkg"
			sudo pacman -Sy --noconfirm "$pkg"
		fi
	done
}

function require_aur() {
	running "require" "arch users repository $1"
	if ! pacman -Qi "$1" >/dev/null 2>&1; then
		action "require" "yay -Sy $1"
		yay -Sy --noconfirm "$pkg"
	fi
}
