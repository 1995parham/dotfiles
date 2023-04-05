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

	msg "use pre-4.0.0 behaviour by cloning the Homebrew/homebrew-core tap during installation
this will make Homebrew install formulae and casks from the homebrew/core and homebrew/cask
taps using local checkouts of these repositories instead of Homebrew’s API."

	export HOMEBREW_NO_INSTALL_FROM_API=1

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
