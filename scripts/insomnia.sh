#!/bin/bash
usage() {
	echo "The easy way to design, debug, and test APIs"

	# shellcheck disable=1004,2016
	echo '
 _                                 _
(_)_ __  ___  ___  _ __ ___  _ __ (_) __ _
| | |_ \/ __|/ _ \| |_ ` _ \| |_ \| |/ _` |
| | | | \__ \ (_) | | | | | | | | | | (_| |
|_|_| |_|___/\___/|_| |_| |_|_| |_|_|\__,_|
  '
}

main_pacman() {
	require_aur insomnia
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	return 0
}

main_parham() {
	mkdir -p "$HOME/.config/Insomnia/" || true

	if [ -d "$HOME/.config/Insomnia/version-control" ]; then
		cd "$HOME/.config/Insomnia/version-control" || return

		url=$(git remote get-url origin 2>/dev/null)
		if [[ "$url" =~ .*github.com[:/]1995parham-me/insomnia ]]; then
			msg 'valid repository, so fetching it'
			git pull origin main

			return 0
		else
			msg "invalid repository $url"

			if yes_or_no "insomnia" "do you want to remove current insomnia configuration?"; then
				msg 'removing current configuration to replace it with new configuration'
				rm -Rf "$HOME/.config/Insomnia/version-control"
			else
				return 1
			fi
		fi
	fi

	if [ -e "$HOME/.config/Insomnia/version-control" ] || [ -L "$HOME/.config/Insomnia/version-control" ]; then
		if yes_or_no "insomnia" "do you want to remove current insomnia configuration?"; then
			msg 'removing current configuration to replace it with new configuration'
			rm -Rf "$HOME/.config/Insomnia/version-control"
		else
			return 1
		fi
	fi
	git clone git@github.com:1995parham-me/insomnia "$HOME/.config/Insomnia/version-control"
}
