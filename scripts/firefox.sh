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
    fi
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

    setup_firefox_profiles

    # defaultbrowser firefox
}

main_pacman() {
    require_pacman firefox

    setup_firefox_profiles

    # xdg-settings set default-web-browser firefox.desktop
}

setup_firefox_policies() {
    running 'firefox' 'Setting up Firefox policies'

    local policies_dir
    local policies_file="$root/firefox/policies.json"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        policies_dir="/Applications/Firefox.app/Contents/Resources/distribution"
    else
        policies_dir="/usr/lib/firefox/distribution"
    fi

    if [[ ! -f "$policies_file" ]]; then
        msg 'firefox' 'policies.json not found, skipping policies setup' 'warn'
        return 0
    fi

    # Create distribution directory if it doesn't exist
    if ! sudo mkdir -p "$policies_dir"; then
        msg 'firefox' 'Failed to create policies directory (sudo required)' 'error'
        return 1
    fi

    # Copy policies.json to distribution directory
    if sudo cp "$policies_file" "$policies_dir/policies.json"; then
        ok 'firefox' 'Firefox policies installed successfully'
        msg 'firefox' "Policies installed to: $policies_dir/policies.json"
    else
        msg 'firefox' 'Failed to install policies.json (sudo required)' 'error'
        return 1
    fi

    sudo chown "$USER" "$policies_dir/policies.json"
}

setup_firefox_profiles() {
    running 'firefox' 'Setting up Firefox profiles'

    check_firefox_running

    local firefox_dir
    local firefox_bin

    if [[ "$OSTYPE" == "darwin"* ]]; then
        firefox_dir="$HOME/Library/Application Support/Firefox"
        firefox_bin="/Applications/Firefox.app/Contents/MacOS/firefox"
    else
        firefox_dir="$HOME/.mozilla/firefox"
        firefox_bin="firefox"
    fi

    mkdir -p "$firefox_dir"

    local profiles_ini="$firefox_dir/profiles.ini"
    local installs_ini="$firefox_dir/installs.ini"
    local root_firefox="$root/firefox"

    # Setup Firefox policies first
    setup_firefox_policies

    # Check if Firefox is installed
    if [[ "$OSTYPE" == "darwin"* ]] && [[ ! -x "$firefox_bin" ]]; then
        msg 'Firefox is not installed at /Applications/Firefox.app' 'error'
        return 1
    fi

    # Create profiles using Firefox's built-in profile manager
    # This ensures the correct InstallHash is generated
    running 'firefox' 'Creating Firefox profiles with correct InstallHash'

    local main_profile_path="main.default"
    local personal_profile_path="personal.default"

    # Check if profiles already exist
    if grep -q "Name=main" "$profiles_ini" 2>/dev/null; then
        msg 'firefox' "Profile 'main' already exists, skipping creation"
    else
        running 'firefox' "Creating 'main' profile"
        "$firefox_bin" -CreateProfile "main $firefox_dir/$main_profile_path" -headless >/dev/null 2>&1
        ok 'firefox' "'main' profile created"
    fi

    if grep -q "Name=personal" "$profiles_ini" 2>/dev/null; then
        msg 'firefox' "Profile 'personal' already exists, skipping creation"
    else
        running 'firefox' "Creating 'personal' profile"
        "$firefox_bin" -CreateProfile "personal $firefox_dir/$personal_profile_path" -headless >/dev/null 2>&1
        ok 'firefox' "'personal' profile created"
    fi

    # Set 'main' as the default profile for this Firefox installation
    if [[ -f "$installs_ini" ]]; then
        running 'firefox' "Setting 'main' as default profile"

        # Extract the InstallHash from installs.ini
        local install_hash
        install_hash=$(head -n1 "$installs_ini" | sed 's/\[\(.*\)\]/\1/')

        if [[ -n "$install_hash" ]]; then
            # Update profiles.ini to set main as default for this installation
            if grep -q "^\[Install$install_hash\]" "$profiles_ini"; then
                # Update existing Install section
                sed -i.bak "/^\[Install$install_hash\]/,/^\[/ s/^Default=.*/Default=$main_profile_path/" "$profiles_ini"
                sed -i.bak "/^\[Install$install_hash\]/,/^\[/ s/^Locked=.*/Locked=1/" "$profiles_ini"
                rm -f "$profiles_ini.bak"
            else
                # Add Install section if it doesn't exist
                echo -e "\n[Install$install_hash]\nDefault=$main_profile_path\nLocked=1" >>"$profiles_ini"
            fi
            ok 'firefox' "'main' set as default profile"
        else
            msg 'firefox' "Could not determine InstallHash, skipping default profile setup" 'warn'
        fi
    fi

    # Configure each profile with user.js and FoxyProxy settings
    export yes_to_all=1

    # Configure main profile
    local main_profile_dir="$firefox_dir/$main_profile_path"
    if [[ -d "$main_profile_dir" ]]; then
        running 'firefox' "Configuring main profile"
        copycat 'firefox' "firefox/main.default.user.js" "$main_profile_dir/user.js" 'false'

        if [[ -f "$root_firefox/foxyproxy-settings.json" ]]; then
            copycat 'firefox' "firefox/foxyproxy-settings.json" "$main_profile_dir/foxyproxy-settings.json" 'false'
        fi

        check_firefox_login "$firefox_dir" "$main_profile_path" "main"
    fi

    # Configure personal profile
    local personal_profile_dir="$firefox_dir/$personal_profile_path"
    if [[ -d "$personal_profile_dir" ]]; then
        running 'firefox' "Configuring personal profile"
        copycat 'firefox' "firefox/personal.default.user.js" "$personal_profile_dir/user.js" 'false'

        if [[ -f "$root_firefox/foxyproxy-settings.json" ]]; then
            copycat 'firefox' "firefox/foxyproxy-settings.json" "$personal_profile_dir/foxyproxy-settings.json" 'false'
        fi

        check_firefox_login "$firefox_dir" "$personal_profile_path" "personal"
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
