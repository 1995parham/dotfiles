#!/usr/bin/env bash

usage() {
    echo "Mozilla Firefox is a free and open-source web browser developed by the Mozilla Foundation, known for privacy, customization, and standards compliance."

    # shellcheck disable=1004,2016
    echo '
  __ _               __
 / _(_)_ __ ___ / _| _____  __
| |_| | |__/ _ \ |_ / _ \ \/ /
|  _| | | |  __/  _| (_) >  <
|_| |_|_|  \___|_|  \___/_/\_\
  '
}

pre_main() {
    msg 'Firefox profiles will be automatically configured' 'info'
    msg 'bookmarks can be synced using Firefox Sync or https://floccus.org/' 'info'
}

main_brew() {
    require_brew_cask firefox
    require_brew defaultbrowser

    # Configure profiles
    setup_firefox_profiles

    defaultbrowser firefox
}

main_pacman() {
    require_pacman firefox

    # Configure profiles
    setup_firefox_profiles

    msg 'set default browser using xdg-settings'
    xdg-settings set default-web-browser firefox.desktop
}

setup_firefox_profiles() {
    if [[ "$(command -v gopass-jsonapi)" ]]; then
        msg 'install gopass-jsonapi native host for firefox'
        gopass-jsonapi configure --browser firefox
    fi

    msg 'Setting up Firefox profiles' 'info'

    # Find Firefox profile directory
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FIREFOX_DIR="$HOME/Library/Application Support/Firefox"
    else
        FIREFOX_DIR="$HOME/.mozilla/firefox"
    fi

    # Create Firefox directory if it doesn't exist
    mkdir -p "$FIREFOX_DIR"

    # Create profiles.ini if it doesn't exist or update it
    PROFILES_INI="$FIREFOX_DIR/profiles.ini"

    if [[ ! -f "$PROFILES_INI" ]]; then
        msg 'Creating profiles.ini' 'info'
        cat >"$PROFILES_INI" <<'EOF'
[Install4F96D1932A9F858E]
Default=main.default
Locked=1

[Profile1]
Name=main
IsRelative=1
Path=main.default
Default=1

[Profile0]
Name=personal
IsRelative=1
Path=personal.default

[General]
StartWithLastProfile=1
Version=2
EOF
    fi

    # Create profile directories
    mkdir -p "$FIREFOX_DIR/main.default"
    mkdir -p "$FIREFOX_DIR/personal.default"

    # Create user.js for main profile
    msg 'Configuring main profile (parham.alvani@gmail.com)' 'info'
    cat >"$FIREFOX_DIR/main.default/user.js" <<'EOF'
// Main Profile Configuration
user_pref("browser.startup.homepage", "about:home");
user_pref("services.sync.username", "parham.alvani@gmail.com");
user_pref("identity.fxaccounts.account.device.name", "Main Profile");
EOF

    # Create user.js for personal profile
    msg 'Configuring personal profile (1995parham@gmail.com)' 'info'
    cat >"$FIREFOX_DIR/personal.default/user.js" <<'EOF'
// Personal Profile Configuration
user_pref("browser.startup.homepage", "about:home");
user_pref("services.sync.username", "1995parham@gmail.com");
user_pref("identity.fxaccounts.account.device.name", "Personal Profile");
EOF

    msg 'Firefox profiles created successfully!' 'success'
    msg 'Launch Firefox and sign in to sync your settings' 'info'
}

main_parham() {
    msg 'Firefox profiles:'
    msg ''
    msg 'Profile 1 (main - default): parham.alvani@gmail.com'
    msg 'Profile 2 (personal): 1995parham@gmail.com'
    msg ''
    msg 'To switch profiles: firefox -P <profile-name>'
    msg 'To open profile manager: firefox -ProfileManager'
}
