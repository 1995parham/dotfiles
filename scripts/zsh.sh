#!/usr/bin/env bash
usage() {
	echo "The Z shell is a Unix shell that can be used as an interactive login shell and as a command interpreter for shell scripting."

	# shellcheck disable=1004,2016
	echo '
         _
 _______| |__
|_  / __| |_ \
 / /\__ \ | | |
/___|___/_| |_|
  '
}

root=${root:?"root must be set"}

pre_main() {
	msg "create zshrc if it doesn't exist"
	if [ ! -f "$HOME/.zshrc" ]; then
		touch "$HOME/.zshrc"
	fi
}

main_pacman() {
	require_pacman zsh
}

main_apt() {
	require_apt zsh
}

main_brew() {
	require_brew zsh zsh-completions

	if ! grep -q -F "if type brew &>/dev/null; then" "$HOME/.zshrc"; then
		tee -a "$HOME/.zshrc" <<EOL
if type brew &>/dev/null; then
  FPATH=\$(brew --prefix)/share/zsh-completions:\$FPATH

  autoload -Uz compinit
  compinit
fi
EOL
	fi

	chmod go-w "$(brew --prefix)/share"
	chmod -R go-w "$(brew --prefix)/share/zsh"

	rm -f ~/.zcompdump
}

main() {
	dotfile "zsh" "zshrc.shared"
	dotfile "zsh" "zshenv"
	dotfile "zsh" "zsh.plug"

	# source zshrc.shared
	if ! grep -q -F "source \$HOME/.zshrc.shared" "$HOME/.zshrc"; then
		echo "source \$HOME/.zshrc.shared" | tee -a "$HOME/.zshrc"
	fi

	# provide dotfile home variable
	if ! grep -q -F "export DOTFILES_ROOT=" "$HOME/.zshrc"; then
		echo "export DOTFILES_ROOT=\"$root\"" | tee -a "$HOME/.zshrc"
	fi
}
