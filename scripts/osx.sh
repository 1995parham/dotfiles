#!/bin/bash

usage() {
	echo "apple osx"
	# shellcheck disable=1004
	echo '
  ___  _____  __
 / _ \/ __\ \/ /
| (_) \__ \>  <
 \___/|___/_/\_\

  '
}

main_brew() {
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	# brew install --cask iglance

	msg 'osx keyring'
	brew install pinentry-mac
	brew install --cask gpg-suite-no-mail
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$dotfiles_root/osx/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}
