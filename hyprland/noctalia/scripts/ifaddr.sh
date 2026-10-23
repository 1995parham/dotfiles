#!/usr/bin/env bash
# the IPv4 addresses of the interfaces matching a glob, waybar's network#<name> modules.
# fails when none of them is up, so the bar widget hides.
# usage: ifaddr.sh [-n] <glob>, -n prefixes each address with its interface name
set -euo pipefail

with_name=false
if [[ ${1:-} == -n ]]; then
    with_name=true
    shift
fi
glob=${1:?"usage: ifaddr.sh [-n] <glob>"}

addresses=()
while read -r name _ address _; do
    name=${name%@*}
    # shellcheck disable=2053
    [[ $name == $glob && -n ${address:-} ]] || continue

    if $with_name; then
        addresses+=("$name: ${address%/*}")
    else
        addresses+=("${address%/*}")
    fi
done < <(ip -4 -brief address)

((${#addresses[@]})) || exit 1
echo "${addresses[*]}"
