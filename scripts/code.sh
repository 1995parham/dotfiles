#!/usr/bin/env bash
usage() {
	echo "Code editing. Redefined."

	# shellcheck disable=1004,2016
	echo '
               _
  ___ ___   __| | ___
 / __/ _ \ / _` |/ _ \
| (_| (_) | (_| |  __/
 \___\___/ \__,_|\___|
  '
}

main_pacman() {
	require_aur visual-studio-code-insiders-bin visual-studio-code-bin
	require_aur devcontainer-cli

	msg 'change password-store to gnome before enabling the sync settings' 'notice'
}

main_brew() {
	require_brew_cask visual-studio-code visual-studio-code-insiders
	require_brew devcontainer
}

main() {
	return 0
}

main_parham() {
	return 0
}
