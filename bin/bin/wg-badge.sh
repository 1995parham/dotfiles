#!/usr/bin/env bash
# tmux status badge for the active wg-quick tunnel(s) on macOS, with LIVE
# reachability checks so the badge reflects a tunnel that works, not one that
# merely has a marker file.
#
#   wg-<name> 🏠 ●  🇮🇷 ●  🌍 ●
#     🏠  home router answers ping through the tunnel (handshake + forwarding OK)
#     🇮🇷  an Iranian site answers  (via the tunnel for iran-access / zitel)
#     🌍  a foreign site answers   (local uplink for iran-access / home,
#                                   via the Iran-only Zi-tel uplink for zitel,
#                                   where red is the expected state)
#   🟢 = answered within the timeout, 🔴 = did not.
#
# Detection uses /var/run/wireguard/<name>.name, which wg-quick writes on `up`
# and removes on `down`; the directory is world-listable so no sudo is needed.
# All probes run in parallel and are bounded to ~3 s. They bypass the shell
# proxy variables: with all_proxy set, curl reports the proxy's connectivity
# instead of ours, a confident wrong answer.
set -u

names=()
for f in /var/run/wireguard/*.name; do
    [[ -e $f ]] || continue
    n="${f##*/}"
    names+=("${n%.name}")
done
((${#names[@]})) || exit 0

probe() {
    env -u all_proxy -u http_proxy -u https_proxy -u ALL_PROXY -u HTTP_PROXY -u HTTPS_PROXY \
        curl -sS -o /dev/null --connect-timeout 2 --max-time 3 "$1" >/dev/null 2>&1
}

ping -c 1 -W 2000 192.168.78.254 >/dev/null 2>&1 &
p_home=$!
probe https://www.digikala.com/ &
p_iran=$!
probe https://1.1.1.1/ &
p_world=$!

# wait in the main shell: inside $(...) the jobs would not be our children
if wait "$p_home"; then home="🟢"; else home="🔴"; fi
if wait "$p_iran"; then iran="🟢"; else iran="🔴"; fi
if wait "$p_world"; then world="🟢"; else world="🔴"; fi

for n in "${names[@]}"; do
    printf 'wg-%s 🏠 %s  🇮🇷 %s  🌍 %s ' "$n" "$home" "$iran" "$world"
done
echo
