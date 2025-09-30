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

    msg 'Lock screen'

    sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Welcome to Parham and Elahe's Mac. Please treat our digital space with the same respect you'd show our home. For access, kindly text or call us."

    msg 'Disable Siri'
    defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
    defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3
    launchctl disable "user/$UID/com.apple.assistantd"
    launchctl disable "gui/$UID/com.apple.assistantd"
    sudo launchctl disable 'system/com.apple.assistantd'
    launchctl disable "user/$UID/com.apple.Siri.agent"
    launchctl disable "gui/$UID/com.apple.Siri.agent"
    sudo launchctl disable 'system/com.apple.Siri.agent'
    defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True
    defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0
    defaults write com.apple.Siri 'StatusMenuVisible' -bool false
    defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true
    defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

    msg "General UI/UX"

    # Close any open System Preferences panes, to prevent them from overriding
    # settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Disable the “Are you sure you want to open this application?” dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Set highlight color to orange
    defaults write NSGlobalDomain AppleAccentColor -int 1
    defaults write NSGlobalDomain AppleAquaColorVariant -int 1
    defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.874510 0.701961 Orange"
    defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

    # Use command + H/L to move between spaces
    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 79 "{ enabled = 1; value = { parameters = ( 65535, 37, 11534336 ); type = 'standard'; }; }"
    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 81 "{ enabled = 1; value = { parameters = ( 65535, 4, 11534336 ); type = 'standard'; }; }"

    # Use tap instead of click. Secondary click with two finger tap.
    defaults write com.apple.driver.AppleMultitouch Clicking -int 1
    defaults write com.apple.driver.AppleMultitouch TrackpadRightClick -bool true
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0

    msg "Dock, Dashboard, Control Center, and hot corners"

    defaults write com.apple.dock persistent-apps -array
    if [[ "$USER" == "parham" ]]; then
        defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Kitty.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'
    else
        defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/iTerm.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'
    fi
    if [[ "$USER" == "parham" ]]; then
        defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Google Chrome.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'
        defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Obsidian.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'
    else
        defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Google Chrome.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'
    fi

    # Dock position on screen
    # options: left, bottom, right
    if [[ "$USER" == "parham" ]]; then
        defaults write com.apple.dock orientation -string "left"
    else
        defaults write com.apple.dock orientation -string "bottom"
    fi

    # Enable file vault
    fdesetup status
    if fdesetup status | grep "Off"; then
        if yes_or_no 'Do you want to enable file vault?'; then
            sudo fdesetup enable
        fi
    fi

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

    # Set timeserver and system timezone
    sudo systemsetup -settimezone GMT
    sudo systemsetup -setusingnetworktime on
    sudo systemsetup -setnetworktimeserver pool.ntp.org

    # Disable gatekeeper
    msg 'Globally disabling the assessment system needs to be confirmed in System Settings means you need set application source from anywhere in the system settings' 'error'
    sudo spctl --master-disable || true

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
    # show in menu bar & show in control center = 3, true
    # show in menu bar & don't show in control center = 6, true
    # don't show in menu bar & show in control center = 9, false
    # don't show in menu bar & don't show in control center = 12, false
    defaults -currentHost write com.apple.controlcenter Battery -int 3
    defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
    # Show percentage
    defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

    # Don’t show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false

    # Set the icon size of Dock items to 36 pixels
    if [[ "$USER" == "parham" ]]; then
        defaults write com.apple.dock tilesize -int 36
    else
        defaults write com.apple.dock tilesize -int 48
    fi

    # Show indicator lights for open applications in the Dock
    defaults write com.apple.dock show-process-indicators -bool true

    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool false

    killall Dock

    # wake the machine when the laptop lid (or clamshell) is opened
    sudo pmset -a lidwake 0

    # change system languages and locale (please logout/login to work)
    defaults write NSGlobalDomain AppleLocale -string en_US
    defaults write NSGlobalDomain AppleLanguages -array "en-US" "fa-IR"

    # change new finder window dafault path
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string "file:///$HOME/Downloads"

    killall Finder

    touch ~/.hushlogin

    msg
    msg 'Setup an internet account for xandikos for Calendar and Contacts' 'notice'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Disable ctrl+space short key to use tmux without pain' 'notice'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Register Right Index Finger for fingerprint sensor' 'notice'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Run "Maccy" and configure it - Lunch at login, Check for updates automatically' 'notice'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Run "KeepingYouAwake" and configure it - Start at login, Activate on Launch, Allow the display to sleep' 'notice'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Configure macos + L and macos + H as mission control short keys' 'notice'
    yes_or_no "macos" 'Did you do it?'
}

main() {
    return 0
}

main_parham() {
    msg 'setting profile picture'
    if [ ! -f 1995parham.png ]; then
        wget https://github.com/1995parham.png
    fi
    if [ ! -f 1995parham.jpg ]; then
        sips -s format jpeg 1995parham.png --out 1995parham.jpg
    fi
    import_profile_pic parham 1995parham.jpg
    rm 1995parham.png
    rm 1995parham.jpg
}

import_profile_pic() {
    user="$1"
    image="$2"
    sudo dscl . delete "/Users/$user" JPEGPhoto
    sudo dscl . delete "/Users/$user" Picture
    tmp="$(mktemp)"
    printf "0x0A 0x5C 0x3A 0x2C dsRecTypeStandard:Users 2 dsAttrTypeStandard:RecordName externalbinary:dsAttrTypeStandard:JPEGPhoto\n%s:%s" "$user" "$image" >"$tmp"
    dsimport "$tmp" /Local/Default M
    rm "$tmp"
}
