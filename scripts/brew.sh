#!/usr/bin/env bash

usage() {
	echo "The missing package manager for macOS (not Linux)"
	echo '
 _
| |__  _ __ _____      __
| |_ \| |__/ _ \ \ /\ / /
| |_) | | |  __/\ V  V /
|_.__/|_|  \___| \_/\_/

  '
}

main_brew() {
	if [[ ! "$(command -v brew)" ]]; then
		xcode-select --install || true

		/usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	# shellcheck disable=2016
	if ! grep -q -F 'eval "$(/opt/homebrew/bin/brew shellenv)"' \
		"$HOME/.zprofile"; then

		# shellcheck disable=2016
		(
			echo
			echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
		) |
			tee -a "$HOME/.zprofile"
	fi

	# provides brew in the current shell
	eval "$(/opt/homebrew/bin/brew shellenv)"
}

main_pacman() {
	return 1
}

main_apt() {
	return 1
}
