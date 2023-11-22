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
	msg "use binaries installed by brew before anything else in the PATH"
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

	msg "Dock, Dashboard, Control Center, and hot corners"

	defaults write com.apple.dock persistent-apps -array
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/kitty.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Google Chrome Beta.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'

	# Dock position on screen
	# options: left, bottom, right
	defaults write com.apple.dock orientation -string "left"

	# Show date
	# when space allows = 0
	# always = 1
	# never = 2
	defaults write com.apple.menuextra.clock ShowDate -int 1

	# Show the day of the week
	defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

	# Style (not analog)
	defaults write com.apple.menuextra.clock IsAnalog -bool false

	# Use a 24-hour clock
	defaults write com.apple.menuextra.clock Show24Hour -bool false

	# Show AM/PM
	defaults write com.apple.menuextra.clock ShowAMPM -bool true

	# Flash the time separators
	defaults write com.apple.menuextra.clock FlashDateSeparators -bool false

	# Display the time with seconds
	defaults write com.apple.menuextra.clock ShowSeconds -bool false

	# Bluetooth
	# show in menu bar = 18, true
	# don't show in menu bar = 24, false
	defaults -currentHost write com.apple.controlcenter Bluetooth -int 18
	defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true

	# Sound
	# always show in menu bar = 18, true
	# show when active = 2
	# don't show in menu bar = 8, false
	defaults -currentHost write com.apple.controlcenter Sound -int 18
	defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

	# Group windows by application
	defaults write com.apple.dock expose-group-apps -bool true

	# Battery
	defaults -currentHost write com.apple.controlcenter Battery -int 12
	defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool false
	# Show percentage
	defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

	# Don’t show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false

	# Set the icon size of Dock items to 36 pixels
	defaults write com.apple.dock tilesize -int 36

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool false

	killall Dock

	# wake the machine when the laptop lid (or clamshell) is opened
	sudo pmset -a lidwake 0
}

main() {
	return 0
}

main_parham() {
	msg 'the wallpapers that we love'

	clone https://github.com/parham-alvani/wallpapers "$HOME/Pictures" "wallpapers"
}
