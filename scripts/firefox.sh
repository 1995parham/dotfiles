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

copy_if_different() {
    local src="$1"
    local dest="$2"

    if [[ ! -f "$src" ]]; then
        return 1
    fi

    # If destination doesn't exist, just copy
    if [[ ! -f "$dest" ]]; then
        cp "$src" "$dest"
        ok 'firefox' "Created: $(basename "$dest")"
        return 0
    fi

    # If files are identical, skip
    if cmp -s "$src" "$dest"; then
        msg "Already up to date: $(basename "$dest")"
        return 0
    fi

    # Files are different, update
    cp "$src" "$dest"
    ok 'firefox' "Updated: $(basename "$dest")"
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

    if [[ "$OSTYPE" == "darwin"* ]]; then
        FIREFOX_DIR="$HOME/Library/Application Support/Firefox"
    else
        FIREFOX_DIR="$HOME/.mozilla/firefox"
    fi

    mkdir -p "$FIREFOX_DIR"

    PROFILES_INI="$FIREFOX_DIR/profiles.ini"
    DOTFILES_FIREFOX="$root/firefox"

    if [[ ! -f "$PROFILES_INI" ]]; then
        running 'firefox' 'Creating profiles.ini from dotfiles'
        if [[ -f "$DOTFILES_FIREFOX/profiles.ini" ]]; then
            cp "$DOTFILES_FIREFOX/profiles.ini" "$PROFILES_INI"
            ok 'firefox' 'profiles.ini created'
        else
            msg 'Warning: profiles.ini not found in dotfiles, using default' 'warn'
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
    elif [[ -f "$DOTFILES_FIREFOX/profiles.ini" ]] && ! cmp -s "$DOTFILES_FIREFOX/profiles.ini" "$PROFILES_INI"; then
        msg 'profiles.ini exists but differs from dotfiles version' 'warn'
        msg 'Skipping profiles.ini update to preserve existing profiles' 'warn'
        msg "To update, manually backup and remove: $PROFILES_INI" 'notice'
    else
        msg 'profiles.ini already up to date'
    fi

    mkdir -p "$FIREFOX_DIR/main.default"
    mkdir -p "$FIREFOX_DIR/personal.default"

    running 'firefox' 'Configuring main profile (parham.alvani@gmail.com)'
    copy_if_different "$DOTFILES_FIREFOX/main.default.user.js" "$FIREFOX_DIR/main.default/user.js"

    running 'firefox' 'Configuring personal profile (1995parham@gmail.com)'
    copy_if_different "$DOTFILES_FIREFOX/personal.default.user.js" "$FIREFOX_DIR/personal.default/user.js"

    if [[ -f "$DOTFILES_FIREFOX/foxyproxy-settings.json" ]]; then
        running 'firefox' 'Copying FoxyProxy settings'
        copy_if_different "$DOTFILES_FIREFOX/foxyproxy-settings.json" "$FIREFOX_DIR/main.default/foxyproxy-settings.json"
        copy_if_different "$DOTFILES_FIREFOX/foxyproxy-settings.json" "$FIREFOX_DIR/personal.default/foxyproxy-settings.json"
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
    msg "   $FIREFOX_DIR/main.default/foxyproxy-settings.json"
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
