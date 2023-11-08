#!/usr/bin/env bash

usage() {
	echo "Radio Javan provides you the best of Persian music. Listen and watch anything you like."

	# shellcheck disable=1004,2016
	echo '
               _ _       _
 _ __ __ _  __| (_) ___ (_) __ ___   ____ _ _ __
| |__/ _` |/ _` | |/ _ \| |/ _` \ \ / / _` | |_ \
| | | (_| | (_| | | (_) | | (_| |\ V / (_| | | | |
|_|  \__,_|\__,_|_|\___// |\__,_| \_/ \__,_|_| |_|
                      |__/
  '
}

version="4.0.1"

main_brew() {
	aria2c "https://s3.amazonaws.com/builds-desktop-rj/Radio%20Javan-$version-universal.dmg" -d "$HOME/Downloads"

	hdiutil attach "$HOME/Downloads/Radio Javan-$version-universal.dmg"
	cp -r "/Volumes/Radio Javan $version-universal/Radio Javan.app" /Applications
	hdiutil detach "/Volumes/Radio Javan $version-universal"
}
