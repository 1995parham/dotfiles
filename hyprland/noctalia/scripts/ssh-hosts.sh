#!/usr/bin/env bash
# the hosts of ~/.ssh/config and the files it includes, for the launcher's /ssh
# like rofi's ssh mode (without parse-known-hosts)
set -euo pipefail

cd "$HOME/.ssh"

configs=(config)
while read -r _ pattern; do
    # shellcheck disable=2206
    configs+=(${pattern/#\~/$HOME})
done < <(grep -i '^[[:space:]]*include[[:space:]]' config)

cat "${configs[@]}" 2>/dev/null |
    awk 'tolower($1) == "host" { for (i = 2; i <= NF; i++) if ($i !~ /[*?!]/) print $i }' |
    sort -u
