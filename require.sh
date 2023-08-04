#!/bin/bash

function require_country() {
	country=$1
	current_country="$(curl -s ipconfig.io/country)"
	if [ "$current_country" != "$country" ]; then
		message "country" "󰈻 please be in $country instead of $current_country" "error"
		return 1
	fi

	return 0
}

function require_host() {
	host=$1
	ping -q -c 1 "$host" || (message "host" "󰈂 please make sure you have access to $host" 'error' && return 1)
}

function not_require_pacman() {
	declare -a to_remove_pkg
	to_remove_pkg=()

	for pkg in "$@"; do
		running "not require" " pacman $pkg"
		if [ "$(pacman -Qq "$pkg" 2>/dev/null)" = "$pkg" ]; then
			to_remove_pkg+=("$pkg")
		fi
	done

	if [ ${#to_remove_pkg[@]} -ne 0 ]; then
		action "not require" " pacman uninstall ${to_remove_pkg[*]}"
		sudo pacman -Rsu "${to_remove_pkg[@]}"
	fi
}

function require_brew() {
	declare -a to_install_pkg
	to_install_pkg=()

	for pkg in "$@"; do
		running "require" " brew $pkg"
		if ! brew list --versions "$pkg" &>/dev/null; then
			to_install_pkg+=("$pkg")
		fi
	done

	if [ ${#to_install_pkg[@]} -ne 0 ]; then
		action "require" " brew install ${to_install_pkg[*]}"
		brew install "${to_install_pkg[@]}"
	fi
}

function require_brew_head() {
	for pkg in "$@"; do
		running "require" " brew head $pkg"
		if ! brew list --versions "$pkg" &>/dev/null; then
			action "require" " brew install --HEAD $pkg"
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
		if ! brew list --cask --versions "$pkg" &>/dev/null; then
			action "require" " brew install --cask $pkg"
			brew install --cask "$pkg"
		fi
	done
}

function require_apt() {
	declare -a to_install_pkg
	to_install_pkg=()

	for pkg in "$@"; do
		running "require" " apt $pkg"
		if ! dpkg -s "$pkg" &>/dev/null; then
			to_install_pkg+=("$pkg")
		fi
	done

	if [ ${#to_install_pkg[@]} -ne 0 ]; then
		action "require" " apt install ${to_install_pkg[*]}"
		sudo apt -qy install "${to_install_pkg[@]}"
	fi
}

function require_pacman() {
	declare -a to_install_pkg
	to_install_pkg=()

	for pkg in "$@"; do
		running "require" " pacman $pkg"
		if ! pacman -Qi "$pkg" &>/dev/null; then
			to_install_pkg+=("$pkg")
		fi
	done

	if [ ${#to_install_pkg[@]} -ne 0 ]; then
		action "require" " pacman -Sy ${to_install_pkg[*]}"
		sudo pacman -Sy --noconfirm "${to_install_pkg[@]}"
	fi
}

function require_aur() {
	for pkg in "$@"; do
		running "require" " arch users repository $pkg"
		if (! pacman -Qi "$pkg" &>/dev/null); then
			action "require" " yay -Sy $pkg"
			yay -Sy --sudoloop --noconfirm "$pkg"
		elif [[ "$pkg" =~ .*-git ]]; then
			if sudo -l; then
				action "require" " yay -Sy $pkg to upgrade -git package"
				yay -Sy --sudoloop --noconfirm "$pkg" || true
			fi
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
		action "require" " go $pkg"
		go install "$pkg@latest" 2>/dev/null
	done
}

function require_pip() {
	for pkg in "$@"; do
		action "require" " python $pkg"
		if (pipx list | grep "$pkg" &>/dev/null); then
			pipx upgrade --pip-args pre "$pkg"
		else
			pipx install --include-deps --pip-args pre "$pkg"
		fi
	done
}

function clone() {
	repo=${1:?"clone requires repository"}
	path=${2:-"."}
	dir=${3:-""}

	if [ ! -d "$path" ]; then
		mkdir -p "$path"
	fi

	repo_name="$(rg -o '\w([:/]\w+[^?]+)' -r '$1' <<<"$repo")"
	repo_name=${repo_name:1}

	if [ "$dir" = "" ]; then
		dir="$(basename "$repo_name")"
	fi

	if [ ! -d "$path/$dir" ]; then
		if git clone "$repo" "$path/$dir" &>/dev/null; then
			action git "$repo_name ${F_GREEN}󰄲${F_RESET}"
		else
			action git "$repo_name ${F_RED}󱋭${F_RESET}"
		fi
	else
		cd "$path/$dir" || return

		origin_url=$(git remote get-url origin 2>/dev/null)

		if [[ "$repo" == "${origin_url%.git}" ]]; then
			action git "$repo_name ${F_GRAY}${F_RESET}"
		else
			action git "$repo_name ($repo != $origin_url) ${F_RED}󱋭${F_RESET}"
		fi

		cd - &>/dev/null || return
	fi
}
