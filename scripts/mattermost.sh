#!/usr/bin/env bash

usage() {
    echo -n -e "desktop client for mattermost, the open-source and self-hosted slack alternative"

    # shellcheck disable=1004,2016
    echo '
                 _   _                                _
 _ __ ___   __ _| |_| |_ ___ _ __ _ __ ___   ___  ___| |_
| |_ ` _ \ / _` | __| __/ _ \ |__| |_ ` _ \ / _ \/ __| __|
| | | | | | (_| | |_| ||  __/ |  | | | | | | (_) \__ \ |_
|_| |_| |_|\__,_|\__|\__\___|_|  |_| |_| |_|\___/|___/\__|
  '
}

root=${root:?"root must be set"}

export additionals=("matterhorn")

main_pacman() {
    require_pacman mattermost-desktop
}

main_brew() {
    require_brew_cask mattermost
}

main_apt() {
    require_snap mattermost-desktop
}

main() {
    local config
    if [[ "$OSTYPE" == "darwin"* ]]; then
        config="$HOME/Library/Application Support/Mattermost/config.json"
    else
        config="${XDG_CONFIG_HOME:-$HOME/.config}/Mattermost/config.json"
    fi

    # the app writes config.json itself (last active server, window state), so
    # the servers are merged into it instead of linking a file from here.
    if [ ! -f "$config" ]; then
        message "mattermost" "open Mattermost once so it creates its config, then run this script again" "notice"
        return 0
    fi

    if pgrep -xi 'mattermost(-desk(top)?)?' >/dev/null 2>&1; then
        message "mattermost" "quit Mattermost first: it keeps its config in memory and writes it back" "warn"
        return 0
    fi

    # add each server whose url is not in the list yet, after the existing ones
    local merged
    merged=$(jq --slurpfile wanted "$root/mattermost/servers.json" '
        def norm: rtrimstr("/");
        (.servers | map(.url | norm)) as $have
        | reduce ($wanted[0][] | select((.url | norm) as $u | $have | index($u) | not)) as $s
            (.; .servers += [$s + {order: (.servers | length)}])
    ' "$config")

    if [ "$merged" = "$(jq . "$config")" ]; then
        message "mattermost" "servers are already configured" "success"
        return 0
    fi

    printf '%s\n' "$merged" >"$config"
    action "mattermost" "servers added: $(jq -r '[.servers[].name] | join(", ")' "$config")"
}
