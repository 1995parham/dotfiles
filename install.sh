#!/bin/bash
set -eu

program_name=$0

usage() {
	echo "usage: $program_name [-h]"
	echo "  -h   display help"
}

# global variable that points to dotfiles root directory
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/message.sh
source "$root/scripts/lib/message.sh"
# shellcheck source=scripts/lib/linker.sh
source "$root/scripts/lib/linker.sh"
# shellcheck source=scripts/lib/header.sh
source "$root/scripts/lib/header.sh"

message "pre" "home directory found at $HOME"

message "pre" "dotfiles found at $root"

while getopts "h" argv; do
	case $argv in
	*)
		usage
		exit
		;;
	esac
done

requirements=(bash zsh tmux vim)

# check the existence of required softwares
for cmd in "${requirements[@]}"; do
	if ! hash "$cmd" 2>/dev/null; then
		message "pre" "Please install $cmd before using this script" "error"
		exit 1
	fi
done

# vim
install-vim() {
	dotfile "vim" "vimrc"
}

# configurations on different tools
# which are installed by ./start.sh env
install-conf() {
	dotfile "conf" "dircolors"
	dotfile "conf" "aria2"

	configfile "htop" "" "conf"

	dotfile "curl" "curlrc"
	dotfile "wget" "wgetrc"
}

# wakatime
install-wakatime() {
	mkdir "$HOME/.wakatime" &>/dev/null || true
	dotfile "wakatime" "wakatime.cfg"
}

# tmux
install-tmux() {
	dotfile "tmux" "tmux.conf"
	configfile "tmuxs" "" "tmux"
	configfile "tmuxp" "" "tmux"

	message "tmux" "installing tmux plugins"
	if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
		mkdir -p ~/.tmux/plugins
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	fi
	"$HOME/.tmux/plugins/tpm/bin/install_plugins"
}

# bin
install-bin() {
	dotfile "bin" "bin" false
}

# general
install-general() {
	if [ "$SHELL" != '/bin/zsh' ]; then
		message "general" "please change your shell to zsh manually"
	fi
}

# calls each module's install function.
modules=(conf tmux wakatime vim bin general)
for module in "${modules[@]}"; do
	message "$module" "---"
	echo
	install-"$module"
	echo
	message "$module" "---"
	echo
done
