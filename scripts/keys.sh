#!/usr/bin/env bash

usage() {
    echo -n "install registered public keys on github <username> as authorized keys ⚠️"
    echo '
 _
| | _____ _   _ ___
| |/ / _ \ | | / __|
|   <  __/ |_| \__ \
|_|\_\___|\__, |___/
          |___/
	'
}

main_pacman() {
    return 0
}

main_apt() {
    return 0
}

main_brew() {
    return 0
}

main_xbps() {
    return 0
}

main_pkg() {
    return 0
}

public() {
    url="https://github.com/$1.keys"

    keys="$(curl -sL "$url")"

    if [ "$keys" = "" ]; then
        msg "no keys found for $1" "error"
        return
    fi

    local ssh_dir="$HOME/.ssh"
    local auth_keys="${ssh_dir}/authorized_keys"

    # ensure ~/.ssh and authorized_keys exist with the perms sshd expects.
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
    touch "$auth_keys"
    chmod 600 "$auth_keys"

    # append only the keys we don't already have so re-running the script
    # is idempotent instead of duplicating every key on each invocation.
    local added=0
    while IFS= read -r key; do
        [ -z "$key" ] && continue

        if grep -qxF "$key" "$auth_keys"; then
            continue
        fi

        # write the source comment once, right before the first new key.
        if [ "$added" -eq 0 ]; then
            printf '\n# %s\n' "$url" >>"$auth_keys"
        fi

        printf '%s\n' "$key" >>"$auth_keys"
        added=$((added + 1))
    done <<<"$keys"

    if [ "$added" -eq 0 ]; then
        msg "all keys for $1 already authorized" "success"
    else
        msg "added ${added} new key(s) for $1" "success"
    fi
}

main() {
    if [ $# -lt 1 ]; then
        msg "./start.sh keys <username>" "error"
        return
    fi

    public "$1"
}
