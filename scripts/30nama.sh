#!/usr/bin/env bash

version="1.3.3"

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
    if [ ! -d /opt/30nama ]; then
        sudo mkdir /opt/30nama
        sudo chown "$USER:$USER" /opt/30nama
    fi

    if [ ! -f /opt/30nama/logo.png ]; then
        aria2c "https://github.com/Mr30nama/30nama/raw/main/logo.png" -d /opt/30nama
    fi

    current_version="$(find /opt/30nama -iname "30nama-*.AppImage" -exec sh -c 'basename $1 .AppImage | cut -d- -f2' sh {} \;)"
    if [ "$current_version" != "" ]; then
        if [ "$(semver_compare "$current_version" "$version")" = "lt" ]; then
            rm "/opt/30nama/30nama-$current_version.AppImage"

            aria2c "https://github.com/Mr30nama/30nama-Hybrid/releases/download/v$version/30nama-$version.AppImage" -d /opt/30nama
            chmod +x "/opt/30nama/30nama-$version.AppImage"
        fi
    else
        aria2c "https://github.com/Mr30nama/30nama-Hybrid/releases/download/v$version/30nama-$version.AppImage" -d /opt/30nama
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

main_brew() {
    aria2c "https://cdn.30nama-hybrid.digital/30nama-$version-arm64.dmg" -d "$HOME/Downloads"
    hdiutil attach "$HOME/Downloads/30nama-$version-arm64.dmg"
    cp -r "/Volumes/30nama $version-arm64/30nama.app" /Applications
    hdiutil detach "/Volumes/30nama $version-arm64"
}
