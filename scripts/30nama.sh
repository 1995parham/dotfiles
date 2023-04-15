#!/bin/bash

version="0.11.2"

usage() {
	echo -n "You will not get bored with 30nama ($version)"
	# shellcheck disable=2016
	echo '
 _____  ___
|___ / / _ \ _ __   __ _ _ __ ___   __ _
  |_ \| | | | |_ \ / _| | |_ | _ \ / _| |
 ___) | |_| | | | | (_| | | | | | | (_| |
|____/ \___/|_| |_|\__,_|_| |_| |_|\__,_|
	'
}

main_pacman() {
	return 0
}

main() {
	if [ ! -d /opt/30nama ]; then
		sudo mkdir /opt/30nama
		sudo chown "$USER:$USER" /opt/30nama
		aria2c "https://github.com/Mr30nama/30nama-Hybrid/releases/download/v$version/30nama-$version.AppImage" -d /opt/30nama
		aria2c "https://github.com/Mr30nama/30nama/raw/main/logo.png" -d /opt/30nama
		chmod +x "/opt/30nama/30nama-$version.AppImage"
	fi

	cat >"$HOME/.local/share/applications/30nama.desktop" <<EOF
  [Desktop Entry]

# The type as listed above
Type=Application

# The version of the desktop entry specification to which this file complies
Version=$version

# The name of the application
Name=30Nama

# A comment which can/will be used as a tooltip
Comment=با ۳۰نما حوصله‌ت سر نمیره!

# The path to the folder in which the executable is run
Path=/opt/30nama

# The executable of the application, possibly with arguments.
Exec=/opt/30nama/30nama-$version.AppImage

# The name of the icon that will be used to display this entry
Icon=/opt/30nama/logo.png

# Describes whether this application needs to be run in a terminal or not
Terminal=false

# Describes the categories in which this entry should be shown
Categories=Entertainment;
EOF
}
