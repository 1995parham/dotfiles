#!/usr/bin/env bash
usage() {
    echo "Slack is a cloud-based freemium cross-platform instant messaging service created by Slack Technologies and currently owned by Salesforce."

    # shellcheck disable=1004,2016
    echo '
     _            _
 ___| | __ _  ___| | __
/ __| |/ _` |/ __| |/ /
\__ \ | (_| | (__|   <
|___/_|\__,_|\___|_|\_\
  '
}

root=${root:?"root must be set"}

main_pacman() {
    require_aur slack-desktop
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask slack
}

main() {
    # Slack keeps themes server-side, so this can only be pasted, not linked.
    # Preferences -> Themes -> Create a custom theme, or paste the line into
    # any message box and hit the Apply button Slack renders for it.
    message "slack" "Orange on black theme: $(cat "${root}/slack/theme.txt")" "notice"
}

main_parham() {
    return 0
}
