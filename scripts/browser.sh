#!/bin/bash

export dependencies=('buku')

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
	require_brew_cask firefox

	gopass-jsonapi configure --browser firefox
}

main_pacman() {
	require_pacman firefox w3m firefox-developer-edition

	if [[ "$(command -v gopass-jsonapi)" ]]; then
		gopass-jsonapi configure --browser firefox
	fi

	if [[ "$(command -v bukubrow)" ]]; then
		bukubrow --install-firefox
	fi

	msg 'set default browser using xdg-settings'
	bash xdg-settings set default-web-browser firefox.desktop

	copycat "browser" "firefox/autoconfig.js" "/usr/lib/firefox/defaults/pref/autoconfig.js"
	copycat "browser" "firefox/firefox.cfg" "/usr/lib/firefox/firefox.cfg"

	if yes_or_no 'browser' 'do you want to install vivaldi?'; then
		require_pacman vivaldi vivaldi-ffmpeg-codecs
	fi

	if yes_or_no 'browser' 'do you want to install edge?'; then
		require_aur microsoft-edge-dev-bin
	fi

	if yes_or_no 'browser' 'do you want to install chrome?'; then
		msg 'chrome, the worst browser ever but sometime we need that shit'
		require_aur google-chrome-beta

		if [[ "$(command -v gopass-jsonapi)" ]]; then
			gopass-jsonapi configure --browser chrome --path ~/.config/google-chrome-beta --manifest-path ~/.config/google-chrome-beta/NativeMessagingHosts/com.justwatch.gopass.json
		fi

		if [[ "$(command -v bukubrow)" ]]; then
			bukubrow --install-chrome --install-dir ~/.config/google-chrome-beta/NativeMessagingHosts/
		fi
	fi
}
