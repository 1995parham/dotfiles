#!/usr/bin/env bash

usage() {
    echo "set hostname based on starship naming schema"

    # shellcheck disable=1004,2016
    echo '
 _               _
| |__   ___  ___| |_ _ __   __ _ _ __ ___   ___
| |_ \ / _ \/ __| __| |_ \ / _` | |_ ` _ \ / _ \
| | | | (_) \__ \ |_| | | | (_| | | | | | |  __/
|_| |_|\___/|___/\__|_| |_|\__,_|_| |_| |_|\___|
  '
}

hostname=""
name=""
to_change=true

pre_main() {
    PS3="select hostname to change into from $HOSTNAME:"

    hostnames=(
        "millennium-falcon:Millennium Falcon"
        "pegasus:Pegasus"
        "x-wing:X Wing"
        "tie-fighter:Tie Fighter"
        "death-star:Death Star"
        "galactica:Galactica"
        "sandcrawler:Sandcrawler"
        "tantive-iv:Tantive IV"
        "cab-46613390:Snapp system name"
    )

    select _hostname in "${hostnames[@]}"; do
        hostname=${_hostname%%:*}
        name=${_hostname##*:}
        msg "changing hostname to $hostname ($name)..."
        break
    done

    if [ "$HOSTNAME" = "$hostname" ]; then
        msg "already has the hostname $hostname"
        to_change=false
    fi
}

main_pacman() {
    if [ "$to_change" ]; then
        msg "using systemd to change hostname to $hostname"
        sudo hostnamectl hostname "$hostname"
    fi
    require_hosts_record "127.0.0.1" "$HOSTNAME"
    require_hosts_record "127.0.0.1" "localhost"
}

main_apt() {
    if [ "$to_change" ]; then
        msg "using systemd to change hostname to $hostname"
        sudo hostnamectl hostname "$hostname"
    fi
    require_hosts_record "127.0.0.1" "$HOSTNAME"
    require_hosts_record "127.0.0.1" "localhost"
}

main_brew() {
    if [ "$to_change" ]; then
        msg "using scutil to change hostname to $hostname"
        sudo scutil --set ComputerName "$name"
        sudo scutil --set HostName "$hostname"
        sudo scutil --set LocalHostName "$hostname"
    fi
}

main() {
    return 0
}
