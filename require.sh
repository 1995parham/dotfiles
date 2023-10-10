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
			action "require" " brew install --fetch $pkg"
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

function require_brew_cask_head() {
	for pkg in "$@"; do
		running "require" " brew cask head $pkg"
		if ! brew list --cask --versions "$pkg" &>/dev/null; then
			action "require" " brew install --cask --fetch $pkg"
			brew install --cask --fetch "$pkg"
		else
			action "require" " brew upgrade --cask --fetch-HEAD $pkg"
			brew upgrade --cask --fetch-HEAD "$pkg"
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
	pkg=${1}
	version=${2:-"latest"}
	action "require" " go $pkg @ $version"
	go install "$pkg@$version" 2>/dev/null
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

function require_npm() {
	for pkg in "$@"; do
		action "require" "󰎙 node $pkg"
		if ! (node -g list "$pkg" &>/dev/null); then
			sudo npm install -g "$pkg"
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

		# origin_url=$(git remote get-url origin 2>/dev/null)
		origin_url=$(git config --get remote.origin.url)

		if [[ "$repo" == "${origin_url%.git}" ]]; then
			action git "$repo_name ${F_GRAY}${F_RESET}"
		else
			action git "$repo_name ($repo != $origin_url) ${F_RED}󱋭${F_RESET}"
		fi

		cd - &>/dev/null || return
	fi
}

function semver_compare() {
	# version1 > version2 -> gt
	# version1 == version2 -> eq
	# version1 < version2 -> lt

	version1=${1:?"version-1 required"}
	version2=${2:?"version-2 required"}

	# first, replace the dots by blank spaces:

	version1=${version1//./ }
	version2=${version2//./ }

	# can get rid of staring 'v':

	version1=${version1//v/}
	version2=${version2//v/}

	patch1="$(echo "$version1" | awk '{print $3}')"
	minor1="$(echo "$version1" | awk '{print $2}')"
	major1="$(echo "$version1" | awk '{print $1}')"

	patch2="$(echo "$version2" | awk '{print $3}')"
	minor2="$(echo "$version2" | awk '{print $2}')"
	major2="$(echo "$version2" | awk '{print $1}')"

	if [ "$major1" -gt "$major2" ]; then
		echo -n "gt"
		return
	elif [ "$major1" -lt "$major2" ]; then
		echo -n "lt"
		return
	fi

	if [ "$minor1" -gt "$minor2" ]; then
		echo -n "gt"
		return
	elif [ "$minor1" -lt "$minor2" ]; then
		echo -n "lt"
		return
	fi

	if [ "$patch1" -gt "$patch2" ]; then
		echo -n "gt"
		return
	elif [ "$patch1" -lt "$patch2" ]; then
		echo -n "lt"
		return
	fi

	echo -n "eq"
}

function require_systemd_kernel_parameter() {
	local new_kernel_parameter=${1:?"new parameter required"}

	for configuration in /boot/loader/entries/*.conf; do
		echo
		message 'systemd-boot' "updating $configuration"
		echo
		message 'systemd-boot' "$(grep options "$configuration")"

		case "$new_kernel_parameter" in
		+*)
			_add_systemd_kernel_parameter "$configuration" "${new_kernel_parameter:1}"
			;;
		-*)
			_remove_systemd_kernel_parameter "$configuration" "${new_kernel_parameter:1}"
			;;
		*)
			_add_systemd_kernel_parameter "$configuration" "$new_kernel_parameter"
			;;
		esac

		message 'systemd-boot' "$(grep options "$configuration")"
		echo
		echo
	done
}

function _add_systemd_kernel_parameter() {
	local configuration=${1:?"systemd-boot loader configuration required"}
	local new_kernel_parameter=${2:?"new parameter required"}

	local kernel_paramters
	declare -a kernel_paramters
	IFS=' ' read -ra kernel_paramters <<<"$(grep options "$configuration")"

	local output
	output=$(echo -n "current kernel_paramters: |")
	output="$output"$(printf "%s|" "${kernel_paramters[@]}")
	message 'systemd-boot' "$output"

	for kernel_parameter in "${kernel_paramters[@]}"; do
		if [ "$kernel_parameter" == "$new_kernel_parameter" ]; then
			message "systemd-boot" "kernel_parameter $new_kernel_parameter already exists"
			return 0
		fi
	done
	kernel_paramters+=("$new_kernel_parameter")

	sudo sed -i -e "s|^options.*$|${kernel_paramters[*]}|" "$configuration"
}

function _remove_systemd_kernel_parameter() {
	local configuration=${1:?"systemd-boot loader configuration required"}
	local new_kernel_parameter=${2:?"new parameter required"}

	local kernel_paramters
	declare -a kernel_paramters
	IFS=' ' read -ra kernel_paramters <<<"$(grep options "$configuration")"

	local output
	output=$(echo -n "current kernel_paramters: |")
	output="$output"$(printf "%s|" "${kernel_paramters[@]}")
	message 'systemd-boot' "$output"

	local found=0
	for index in "${!kernel_paramters[@]}"; do
		if [ "${kernel_paramters[$index]}" == "$new_kernel_parameter" ]; then
			unset "kernel_paramters[$index]"
			found=1
		fi
	done

	if [ "$found" -eq 1 ]; then
		sudo sed -i -e "s|^options.*$|${kernel_paramters[*]}|" "$configuration"
	fi
}
