#!/bin/bash

usage() {
	echo "install firefox, firefox-developer-edition and tridactyl configuration"
	echo '
 _
| |__  _ __ _____      _____  ___ _ __
| |_ \| |__/ _ \ \ /\ / / __|/ _ \ |__|
| |_) | | | (_) \ V  V /\__ \  __/ |
|_.__/|_|  \___/ \_/\_/ |___/\___|_|

	'
}

main_brew() {
	brew install --cask firefox
}

main_pacman() {
	require_pacman firefox w3m firefox-developer-edition

	gopass-jsonapi configure --browser firefox

	msg 'set default browser using xdg-settings'
	bash xdg-settings set default-web-browser firefox.desktop

	msg 'nyxt - the internet on your terms'
	require_pacman nyxt

	if yes_or_no 'browser' 'do you want to install vivaldi?'; then
		require_pacman vivaldi vivaldi-ffmpeg-codecs
	fi

	if yes_or_no 'browser' 'do you want to install chrome?'; then
		msg 'chrome, the worst browser ever but sometime we need that shit'
		require_aur google-chrome-beta

		dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}
		msg 'providing chrome-beta-flags.conf'
		linker "browser" "$dotfiles_root/chrome/chrome-beta-flags.conf" "$HOME/.config/chrome-beta-flags.conf"

		gopass-jsonapi configure --browser chrome --path ~/.config/google-chrome-beta --manifest-path ~/.config/google-chrome-beta/NativeMessagingHosts/com.justwatch.gopass.json
	fi
}

main() {
	configfile nyxt

	# actually it is not useful as I think so I disable it.
	# msg "install tridactyl by running :installnative in firefox normal mode"
	# configfile tridactyl "" firefox
}
