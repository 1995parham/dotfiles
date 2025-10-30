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

root=${root:?"root must be set"}

pre_main() {
    msg 'Firefox profiles will be automatically configured'
    msg 'bookmarks can be synced using Firefox Sync or https://floccus.org/'
}

check_firefox_running() {
    if pgrep -x firefox >/dev/null 2>&1; then
        msg 'Warning: Firefox is currently running' 'warn'
        msg 'Some changes may not take effect until Firefox is restarted' 'warn'
        return 0
    fi
    return 1
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

    setup_firefox_profiles

    msg 'set default browser using xdg-settings'
    xdg-settings set default-web-browser firefox.desktop
}

setup_firefox_profiles() {
    if [[ "$(command -v gopass-jsonapi)" ]]; then
        running 'firefox' 'install gopass-jsonapi native host for firefox'
        gopass-jsonapi configure --browser firefox
    fi

    running 'firefox' 'Setting up Firefox profiles'

    check_firefox_running

    local firefox_dir

    if [[ "$OSTYPE" == "darwin"* ]]; then
        firefox_dir="$HOME/Library/Application Support/Firefox"
    else
        firefox_dir="$HOME/.mozilla/firefox"
    fi

    mkdir -p "$firefox_dir"

    profiles_ini="$firefox_dir/profiles.ini"
    root_firefox="$root/firefox"

    if [[ ! -f "$profiles_ini" ]]; then
        running 'firefox' 'Creating profiles.ini from dotfiles'
        if [[ -f "$root_firefox/profiles.ini" ]]; then
            cp "$root_firefox/profiles.ini" "$profiles_ini"
            ok 'firefox' 'profiles.ini created'
        else
            msg 'Warning: profiles.ini not found in dotfiles, using default' 'warn'
            cat >"$profiles_ini" <<'EOF'
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
    elif [[ -f "$root_firefox/profiles.ini" ]] && ! cmp -s "$root_firefox/profiles.ini" "$profiles_ini"; then
        msg 'profiles.ini exists but differs from dotfiles version' 'warn'
        msg 'Skipping profiles.ini update to preserve existing profiles' 'warn'
        msg "To update, manually backup and remove: $profiles_ini" 'notice'
    else
        msg 'profiles.ini already up to date'
    fi

    mkdir -p "$firefox_dir/main.default"
    mkdir -p "$firefox_dir/personal.default"

    running 'firefox' 'Configuring main profile (parham.alvani@gmail.com)'
    copycat 'firefox' "$root_firefox/main.default.user.js" "$firefox_dir/main.default/user.js" 'false'

    running 'firefox' 'Configuring personal profile (1995parham@gmail.com)'
    copycat 'firfox' "$root_firefox/personal.default.user.js" "$firefox_dir/personal.default/user.js" 'false'

    if [[ -f "$root_firefox/foxyproxy-settings.json" ]]; then
        running 'firefox' 'Copying FoxyProxy settings'
        copycat 'firefox' "$root_firefox/foxyproxy-settings.json" "$firefox_dir/main.default/foxyproxy-settings.json" 'false'
        copycat 'firefox' "$root_firefox/foxyproxy-settings.json" "$firefox_dir/personal.default/foxyproxy-settings.json" 'false'
    fi

    ok 'firefox' 'Firefox profiles setup completed!'
    msg 'Launch Firefox and sign in to sync your settings'

    setup_foxyproxy_instructions
}

setup_foxyproxy_instructions() {
    echo
    msg '========================================'
    msg 'FoxyProxy Setup Instructions:' 'notice'
    msg '========================================'
    msg '1. Install FoxyProxy extension from:'
    msg '   https://addons.mozilla.org/firefox/addon/foxyproxy-standard/'
    echo
    msg '2. After installation, click FoxyProxy icon → Options'
    echo
    msg '3. Click "Import Settings" and select:'
    msg "   $firefox_dir/main.default/foxyproxy-settings.json"
    msg '   (or personal.default for personal profile)'
    echo
    msg '4. Configuration includes:'
    msg '   - Proxy: 127.0.0.1:2081'
    msg '   - Iranian websites (.ir) bypass proxy'
    msg '   - Local networks bypass proxy'
    msg '   - DuckDuckGo as default search engine'
    msg '========================================'
}

main_parham() {
    msg 'Firefox profiles:'
    echo
    msg 'Profile 1 (main - default): parham.alvani@gmail.com'
    msg 'Profile 2 (personal): 1995parham@gmail.com'
    echo
    msg 'To switch profiles: firefox -P <profile-name>'
    msg 'To open profile manager: firefox -ProfileManager'
}
