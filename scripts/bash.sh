#!/usr/bin/env bash
usage() {
	echo "Bash is a Unix shell and command language written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell."

	# shellcheck disable=1004,2016
	echo '
 _               _
| |__   __ _ ___| |__
| |_ \ / _` / __| |_ \
| |_) | (_| \__ \ | | |
|_.__/ \__,_|___/_| |_|
  '
}

root=${root:?"root must be set"}

main_pacman() {
	require_pacman bash bash-completion
}

main_apt() {
	require_apt bash
}

main_brew() {
	require_brew bash
}

main() {
	dotfile "bash" "bashrc.shared"

	# create bashrc if it doesn't exists
	if [ ! -f "$HOME/.bashrc" ]; then
		touch "$HOME/.bashrc"
	fi

	# source bashrc.shared
	if ! grep -q -F "source \$HOME/.bashrc.shared" "$HOME/.bashrc"; then
		echo "source \$HOME/.bashrc.shared" | tee -a "$HOME/.bashrc"
	fi

	# provide dotfile home variable
	if ! grep -q -F "export DOTFILES_ROOT=" "$HOME/.bashrc"; then
		echo "export DOTFILES_ROOT=\"$root\"" | tee -a "$HOME/.bashrc"
	fi
}
