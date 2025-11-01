#!/usr/bin/env bash

usage() {
    echo -n "Fast, secure tunnels to localhost - ngrok"
    # shellcheck disable=2016
    echo '
                         _
 _ __   __ _ _ __ ___ | | __
|  _ \ / _  |  __/ _ \| |/ /
| | | | (_| | | | (_) |   <
|_| |_|\__, |_|  \___/|_|\_\
       |___/
	'
}

main_pacman() {
    require_aur ngrok
}

main_brew() {
    require_brew_cask ngrok
}

main_apt() {
    require_apt ngrok
}

main() {
    msg "You need to sign up at https://dashboard.ngrok.com/signup to get an auth token" "notice"
    msg "After signing up, configure your auth token with: ngrok config add-authtoken <TOKEN>" "notice"
    msg "Start a tunnel with: ngrok http 8080 (or any port you want to expose)" "info"
    msg "For more options, visit: https://ngrok.com/docs" "info"
    return 0
}
