#!/bin/bash

version="1.10.1"

usage() {
	echo -n "The Outline clients use the popular Shadowsocks protocol ($version)"
	# shellcheck disable=2016
	echo '
             _   _ _
  ___  _   _| |_| (_)_ __   ___
 / _ \| | | | __| | | |_ \ / _ \
| (_) | |_| | |_| | | | | |  __/
 \___/ \__,_|\__|_|_|_| |_|\___|

	'
}

main_pacman() {
	return 0
}

main() {
	if [ ! -d /opt/outline ]; then
		sudo mkdir /opt/outline
		sudo chown "$USER:$USER" /opt/outline
		aria2c "https://github.com/Jigsaw-Code/outline-client/releases/download/v$version/Outline-Client.AppImage" -d /opt/outline
		aria2c "https://github.com/Jigsaw-Code/outline-client/blob/master/resources/icons/ios/Icon-512@2x.png?raw=true" -d /opt/outline
		chmod +x "/opt/outline/Outline-Client.AppImage"
	fi

	cat >"$HOME/.local/share/applications/outline.desktop" <<EOF
  [Desktop Entry]

# The type as listed above
Type=Application

# The version of the desktop entry specification to which this file complies
Version=$version

# The name of the application
Name=Outline

# A comment which can/will be used as a tooltip
Comment=Outline clients, developed by Jigsaw. The Outline clients use the popular Shadowsocks protocol, and lean on the Cordova and Electron frameworks to support Windows, Android / ChromeOS, Linux, iOS and macOS.

# The path to the folder in which the executable is run
Path=/opt/outline

# The executable of the application, possibly with arguments.
Exec=/opt/outline/Outline-Client.AppImage

# The name of the icon that will be used to display this entry
Icon=/opt/outline/Icon-512@2x.png

# Describes whether this application needs to be run in a terminal or not
Terminal=false

# Describes the categories in which this entry should be shown
Categories=Entertainment;
EOF
}
