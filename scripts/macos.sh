#!/usr/bin/env bash
usage() {
	echo "setup macos and aqua"

	# shellcheck disable=1004,2016
	echo '

 _ __ ___   __ _  ___ ___  ___
| |_ ` _ \ / _` |/ __/ _ \/ __|
| | | | | | (_| | (_| (_) \__ \
|_| |_| |_|\__,_|\___\___/|___/
  '
}

main_brew() {
	msg "use binaries installed by brew before anything else"
	copycat "macos" "osx/paths" "/etc/paths"

	msg "General UI/UX"

	# Close any open System Preferences panes, to prevent them from overriding
	# settings we’re about to change
	osascript -e 'tell application "System Preferences" to quit'

	# Disable the “Are you sure you want to open this application?” dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	# Set highlight color to orange
	defaults write NSGlobalDomain AppleAquaColorVariant -int 1
	defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.874510 0.701961 Orange"
	defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

	# Use tap instead of click. Secondary click with two finger tap.
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 2

	msg "Dock, Dashboard, and hot corners"

	defaults write com.apple.dock persistent-apps -array
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/kitty.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'

	# Don’t show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false

	# Set the icon size of Dock items to 36 pixels
	defaults write com.apple.dock tilesize -int 36

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true

	killall Dock
}

main() {
	return 0
}

main_parham() {
	return 0
}
