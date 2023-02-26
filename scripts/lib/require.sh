#!/bin/bash

function require_brew() {
	for pkg in "$@"; do
		running "require" " brew $pkg"
		if ! brew list --versions "$pkg" >/dev/null 2>&1; then
			action "require" "勒brew install $pkg"
			brew install "$pkg"
		fi
	done
}

function require_brew_head() {
	for pkg in "$@"; do
		running "require" " brew head $pkg"
		if ! brew list --versions "$pkg" >/dev/null 2>&1; then
			action "require" "勒brew install --HEAD $pkg"
			brew install --HEAD "$pkg"
		else
			action "require" " brew upgrade --fetch-HEAD $pkg"
			brew upgrade --fetch-HEAD "$pkg"
		fi
	done
}

function require_brew_cask() {
	for pkg in "$@"; do
		running "require" " brew cask $pkg"
		if ! brew list --cask --versions "$pkg" >/dev/null 2>&1; then
			action "require" "勒brew install --cask $pkg"
			brew install --cask "$pkg"
		fi
	done
}

function require_pacman() {
	for pkg in "$@"; do
		running "require" " pacman $pkg"
		if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
			action "require" "勒pacman -Sy $pkg"
			sudo pacman -Sy --noconfirm "$pkg"
		fi
	done
}

function require_aur() {
	for pkg in "$@"; do
		running "require" " arch users repository $pkg"
		if (! pacman -Qi "$pkg" >/dev/null 2>&1); then
			action "require" "勒yay -Sy $pkg"
			yay -Sy --sudoloop --noconfirm "$pkg"
		elif [[ "$pkg" =~ .*-git ]]; then
			action "require" " yay -Sy $pkg to upgrade -git package"
			yay -Sy --sudoloop --noconfirm "$pkg" || true
		fi
	done
}

function require_mason() {
	for pkg in "$@"; do
		action "require" " neovim + mason $pkg"
		nvim "+MasonInstall $pkg" --headless +qall 2>/dev/null
	done
}

function require_go() {
	for pkg in "$@"; do
		action "require" "ﳑ go $pkg"
		go install "$pkg@latest" 2>/dev/null
	done
}

function require_pip() {
	for pkg in "$@"; do
		action "require" " python $pkg"
		python -mpip install --user --pre -U "$pkg" 2>/dev/null
	done
}
