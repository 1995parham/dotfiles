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

app_exists() {
    local app_path="$1"
    if [ -d "$app_path" ]; then
        return 0
    else
        return 1
    fi
}

add_to_dock_if_exists() {
    local app_path="$1"
    local app_name
    app_name=$(basename "$app_path")

    if app_exists "$app_path"; then
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file://$app_path</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
        list_item "$app_name" "success" 1
    else
        list_item "$app_name (not found)" "warning" 1
    fi
}

main_brew() {
    section_header "System Configuration" 60 "="

    msg 'Lock screen'

    sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Welcome to Parham and Elaheh's Mac. Please treat our digital space with the same respect you'd show our home. For access, kindly text or call us."

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

    section_header "General UI/UX" 60 "="

    # Close any open System Preferences panes, to prevent them from overriding
    # settings we're about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Disable the “Are you sure you want to open this application?” dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Set highlight color to orange
    defaults write NSGlobalDomain AppleAccentColor -int 1
    defaults write NSGlobalDomain AppleAquaColorVariant -int 1
    defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.874510 0.701961 Orange"
    defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

    section_header "Keyboard & Shortcuts" 60 "="

    running 'Configuring keyboard shortcuts'

    # Use command + H/L to move between spaces
    # Modifier value: Command = 1048576
    # Key code: H = 4, L = 37
    # ASCII: 104 (h), 108 (l)
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "<dict><key>enabled</key><true/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>104</integer><integer>4</integer><integer>1048576</integer></array></dict></dict>"
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "<dict><key>enabled</key><true/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>108</integer><integer>37</integer><integer>1048576</integer></array></dict></dict>"

    # Disable Ctrl+Space (Input Source switching) to avoid conflicts with tmux
    # Key 60 = "Select the previous input source" (Ctrl+Space)
    # Key 61 = "Select next source in Input menu" (Ctrl+Option+Space)
    /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c "Set AppleSymbolicHotKeys:60:enabled false" 2>/dev/null || true
    /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c "Set AppleSymbolicHotKeys:61:enabled false" 2>/dev/null || true

    # Apply keyboard shortcut changes immediately
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    ok 'Keyboard shortcuts configured and activated'

    section_header "Trackpad" 60 "="

    # Use tap instead of click. Secondary click with two finger tap.
    defaults write com.apple.driver.AppleMultitouch Clicking -int 1
    defaults write com.apple.driver.AppleMultitouch TrackpadRightClick -bool true
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0

    section_header "Dock & Applications" 60 "="

    running 'Configuring dock applications'

    defaults write com.apple.dock persistent-apps -array
    if [[ "$USER" == "parham" ]]; then
        add_to_dock_if_exists "/Applications/Kitty.app"
        add_to_dock_if_exists "/Applications/Firefox.app"
    else
        add_to_dock_if_exists "/Applications/iTerm.app"
    fi
    if [[ "$USER" == "parham" ]]; then
        add_to_dock_if_exists "/Applications/Google Chrome.app"
        add_to_dock_if_exists "/Applications/Obsidian.app"
    else
        add_to_dock_if_exists "/Applications/Google Chrome.app"
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

    section_header "Menu Bar & Control Center" 60 "="

    running 'Configuring menu bar and control center items'

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

    ok 'Menu bar and control center configured'

    section_header "Security & Privacy" 60 "="

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
    ok 'Dock configured and restarted'

    section_header "Locale & Finder" 60 "="

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

    section_header "Manual Setup Required" 60 "="

    # Architecture for "Did you do it?" interactive prompts:
    # Each manual configuration step follows this pattern:
    # 1. Empty msg line for spacing
    # 2. Main prompt with 'notice' type describing what needs to be done
    # 3. Detailed step-by-step instructions using msg with 'info' type:
    #    - Start each step with numbered list (1., 2., 3., etc.)
    #    - Include exact paths to System Settings or app locations
    #    - Provide specific UI elements to click/check/uncheck
    #    - Add context about what each step accomplishes
    #    - Include a "Quick command" line with an 'open' command to launch settings directly
    # 4. yes_or_no call with "macos" context and 'Did you do it?' question
    #
    # This format ensures users have complete information to perform manual tasks
    # without needing to search for settings or guess at paths.

    msg
    msg 'Setup an internet account for xandikos for Calendar and Contacts' 'notice'
    msg '  1. Open System Settings > Internet Accounts' 'info'
    msg '  2. Click "Add Account..." button' 'info'
    msg '  3. Select "Add Other Account..." at the bottom' 'info'
    msg '  4. Choose "CalDAV account" for Calendar or "CardDAV account" for Contacts' 'info'
    msg '  5. Enter your xandikos server details (server address, username, password)' 'info'
    msg '  6. Repeat steps 3-5 for the other service if needed' 'info'
    msg '  Quick command to open settings: open "x-apple.systempreferences:com.apple.Internet-Accounts"' 'info'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Register Right Index Finger for fingerprint sensor' 'notice'
    msg '  1. Open System Settings > Touch ID & Password' 'info'
    msg '  2. Click the lock icon to authenticate' 'info'
    msg '  3. Click "Add Fingerprint..." button' 'info'
    msg '  4. Follow the on-screen instructions to scan your right index finger' 'info'
    msg '  5. Lift and rest your finger repeatedly until the fingerprint is fully registered' 'info'
    msg '  Quick command to open settings: open "x-apple.systempreferences:com.apple.preferences.password"' 'info'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Run "Maccy" and configure it - Launch at login, Check for updates automatically' 'notice'
    msg '  1. Launch Maccy from Applications folder or Spotlight' 'info'
    msg '  2. Click the Maccy icon in the menu bar' 'info'
    msg '  3. Select "Preferences..." from the dropdown menu' 'info'
    msg '  4. In the "General" tab, check "Launch at login"' 'info'
    msg '  5. In the "General" tab, check "Check for updates automatically"' 'info'
    msg '  6. Adjust other settings as needed (e.g., paste automatically, sound effects)' 'info'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Run "KeepingYouAwake" and configure it - Start at login, Activate on Launch, Allow the display to sleep' 'notice'
    msg '  1. Launch KeepingYouAwake from Applications folder or Spotlight' 'info'
    msg '  2. Click the KeepingYouAwake icon in the menu bar (coffee cup icon)' 'info'
    msg '  3. Select "Preferences..." from the dropdown menu' 'info'
    msg '  4. In the "General" tab, check "Start at login"' 'info'
    msg '  5. Check "Activate on Launch" to automatically prevent sleep when app starts' 'info'
    msg '  6. Check "Allow the display to sleep" to only prevent system sleep, not screen sleep' 'info'
    yes_or_no "macos" 'Did you do it?'

    msg
    msg 'Grant Full Disk Access to Terminal for unrestricted file access' 'notice'
    msg '  1. Open System Settings > Privacy & Security > Full Disk Access' 'info'
    msg '  2. Click the lock icon to authenticate' 'info'
    msg '  3. Click the + button and add your terminal app:' 'info'
    msg '     - Terminal.app: /Applications/Utilities/Terminal.app' 'info'
    msg '     - iTerm2: /Applications/iTerm.app' 'info'
    msg '     - Kitty: /Applications/Kitty.app' 'info'
    msg '  4. Restart your terminal after granting access' 'info'
    msg '  Quick command to open settings: open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"' 'info'
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
