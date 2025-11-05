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

check_firefox_login() {
    local firefox_dir="$1"
    local profile_path="$2"
    local profile_name="$3"

    local profile_dir="$firefox_dir/$profile_path"

    # Check if signedInUser.json exists (indicates Firefox account login)
    if [[ -f "$profile_dir/signedInUser.json" ]] && [[ -s "$profile_dir/signedInUser.json" ]]; then
        ok 'firefox' "Profile '$profile_name' is logged in"
        return 0
    fi

    msg 'firefox' "Profile '$profile_name' is not logged in" 'warn'

    # Check if gopass is available
    if command -v gopass >/dev/null 2>&1; then
        ok 'firefox' 'gopass is installed and available'
        msg 'firefox' "Retrieve password with: gopass show -c <password-path>" 'notice'

        # Ask user if they want to open Firefox to login
        if yes_or_no 'firefox' "Would you like to open Firefox '$profile_name' profile to login?"; then
            running 'firefox' "Opening Firefox with '$profile_name' profile..."
            if [[ "$OSTYPE" == "darwin"* ]]; then
                /Applications/Firefox.app/Contents/MacOS/firefox -P "$profile_name" &
            else
                firefox -P "$profile_name" &
            fi
            ok 'firefox' "Firefox opened. Please log in with your account"
        fi
    else
        msg 'firefox' 'gopass is not installed' 'warn'
        msg 'firefox' 'Install gopass for password management to enable login assistance' 'notice'
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

    if [[ -f "$profiles_ini" ]]; then
        export yes_to_all=1

        while IFS= read -r line; do
            profile_path=$(echo "$line" | cut -d'=' -f2)
            profile_dir="$firefox_dir/$profile_path"
            mkdir -p "$profile_dir"

            profile_name=$(grep -B2 "$line" "$profiles_ini" | grep '^Name=' | cut -d'=' -f2)

            case "$profile_name" in
            main)
                running 'firefox' "Configuring main profile ($profile_path)"
                copycat 'firefox' "firefox/main.default.user.js" "$profile_dir/user.js" 'false'
                ;;
            personal)
                running 'firefox' "Configuring personal profile ($profile_path)"
                copycat 'firefox' "firefox/personal.default.user.js" "$profile_dir/user.js" 'false'
                ;;
            *)
                msg "Unknown profile '$profile_name' found, skipping user.js configuration." "warn"
                ;;
            esac

            if [[ -f "$root_firefox/foxyproxy-settings.json" ]]; then
                running 'firefox' "Copying FoxyProxy settings to $profile_path"
                copycat 'firefox' "firefox/foxyproxy-settings.json" "$profile_dir/foxyproxy-settings.json" 'false'
            fi

            check_firefox_login "$firefox_dir" "$profile_path" "$profile_name"
        done < <(grep -E '^Path=' "$profiles_ini")
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
    msg '3. Click "Import Settings" and select the "foxyproxy-settings.json" file'
    msg '   from your desired profile directory inside:'
    msg "   $firefox_dir"
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
