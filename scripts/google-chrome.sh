#!/usr/bin/env bash
usage() {
    echo ""

    # shellcheck disable=1004,2016
    echo '
                         _                 _
  __ _  ___   ___   __ _| | ___        ___| |__  _ __ ___  _ __ ___   ___
 / _` |/ _ \ / _ \ / _` | |/ _ \_____ / __| |_ \| |__/ _ \| |_ ` _ \ / _ \
| (_| | (_) | (_) | (_| | |  __/_____| (__| | | | | | (_) | | | | | |  __/
 \__, |\___/ \___/ \__, |_|\___|      \___|_| |_|_|  \___/|_| |_| |_|\___|
 |___/             |___/
  '
}

pre_main() {
    msg 'bookmarks are synced using https://floccus.org/' 'info'
}

main_brew() {
    require_brew_cask google-chrome@beta
    require_brew_cask google-chrome@dev
    require_brew defaultbrowser

    if [[ "$(command -v gopass-jsonapi)" ]]; then
        msg 'install gopass-jsonapi native host for google chrome beta'
        gopass-jsonapi configure --browser chrome --path "$HOME/Library/Application Support/Google/Chrome Beta" \
            --manifest-path "$HOME/Library/Application Support/Google/Chrome Beta/NativeMessagingHosts/com.justwatch.gopass.json"
        msg 'install gopass-jsonapi native host for google chrome dev'
        gopass-jsonapi configure --browser chrome --path "$HOME/Library/Application Support/Google/Chrome Dev" \
            --manifest-path "$HOME/Library/Application Support/Google/Chrome Dev/NativeMessagingHosts/com.justwatch.gopass.json"
    fi

    defaultbrowser dev
}

main_pacman() {
    require_aur google-chrome-beta google-chrome-dev

    if [[ "$(command -v gopass-jsonapi)" ]]; then
        msg 'install gopass-jsonapi native host for google chrome beta'
        gopass-jsonapi configure --browser chrome --path ~/.config/google-chrome-beta --manifest-path ~/.config/google-chrome-beta/NativeMessagingHosts/com.justwatch.gopass.json
        msg 'install gopass-jsonapi native host for google chrome dev'
        gopass-jsonapi configure --browser chrome --path ~/.config/google-chrome-dev --manifest-path ~/.config/google-chrome-dev/NativeMessagingHosts/com.justwatch.gopass.json
    fi

    msg 'set default browser using xdg-settings'
    bash xdg-settings set default-web-browser google-chrome-dev.desktop
}
