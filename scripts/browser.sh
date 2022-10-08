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

	msg 'set default browser using xdg-settings'
	bash xdg-settings set default-web-browser firefox.desktop

	msg 'nyxt - the internet on your terms'
	require_pacman nyxt

	if yes_or_no 'browser' 'do you want to install vivaldi?'; then
		require_pacman vivaldi
		require_pacman vivaldi-ffmpeg-codecs
	fi

	if yes_or_no 'browser' 'do you want to install chrome?'; then
		msg 'chrome, the worst browser ever but sometime we need that shit'
		require_aur google-chrome-beta

		msg 'please set following flags in _chrome://flags_ to use it in wayland:'
		msg '_WebRTC PipeWire support_ to _enabled_'
		msg '_Preferred Ozone platform_ to _auto_'
	fi
}

main() {
	configfile nyxt

	msg "install tridactyl by running :installnative in firefox normal mode"
	configfile tridactyl "" firefox
}
