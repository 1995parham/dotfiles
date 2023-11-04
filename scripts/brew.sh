#!/bin/bash

usage() {
	echo "The missing package manager for macOS (or Linux)"
	echo '
 _
| |__  _ __ _____      __
| |_ \| |__/ _ \ \ /\ / /
| |_) | | |  __/\ V  V /
|_.__/|_|  \___| \_/\_/

  '
}

main_brew() {
	xcode-select --install

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# shellcheck disable=2016
	(
		echo
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
	) >>/Users/parham/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"

	# shellcheck disable=2016
	echo 'path=("/opt/homebrew/bin" $path)' >>~/.zshrc
	echo 'export PATH' >>~/.zshrc

	msg 'add cask-versions for finding alternative versions of Casks'
	brew tap homebrew/cask-versions
}

main_pacman() {
	return 1
}

main_apt() {
	require_apt build-essential procps curl file git

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	msg "add homebrew to your profile"

	test -d "$HOME/.linuxbrew" && eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"

	test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

	test -d /opt/homebrew/bin/ && eval "$(/opt/homebrew/bin/brew shellenv)"

	brew_eval="eval \$($(brew --prefix)/bin/brew shellenv)"

	if [ -r "$HOME/.bash_profile" ]; then
		grep -i "$brew_eval" "$HOME/.bash_profile" || echo "$brew_eval" >>"$HOME/.bash_profile"
	fi
	grep -i "$brew_eval" "$HOME/.profile" || echo "$brew_eval" >>"$HOME/.profile"
}
