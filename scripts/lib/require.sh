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
	for pkg in "$@"; do
		running "require" "arch users repository $pkg"
		if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
			action "require" "yay -Sy $pkg"
			yay -Sy --noconfirm "$pkg"
		fi
	done
}
