#!/usr/bin/env bash
# tmux status badge for the active home tunnel -- WireGuard OR sing-box -- with
# LIVE reachability checks, so the badge reflects a tunnel that works rather
# than one that merely left a marker file behind.
#
#   sing-box 🏠 🟢  🇮🇷 🟢  🌍 🟢
#     name  the tunnel actually carrying the house right now
#     🏠    the home LAN answers through the tunnel
#     🇮🇷    an Iranian site answers (through the tunnel)
#     🌍    a foreign site answers   (local uplink / Speedify)
#   🟢 = answered within the timeout, 🔴 = did not.
#
# Replaces the older wg-badge.sh, which detected wg-quick only and so printed
# NOTHING once the house moved to sing-box -- a silent blank where the whole
# point is at-a-glance state.
#
# The home probe is HTTP, not ping, and that matters: sing-box's gvisor TUN
# answers ICMP for routed addresses itself, so a ping to the home LAN succeeds
# in ~0.4 ms whether or not the tunnel can actually carry anything. It is a
# green light wired to nothing.
#
# All probes run in parallel, bounded to ~3 s, and bypass the shell proxy
# variables: with all_proxy set, curl reports the PROXY's connectivity instead
# of ours -- a confident wrong answer.
set -u

# --- which tunnel is up ----------------------------------------------------
name=""
if pgrep -f "sing-box run -c .*tun.json" >/dev/null 2>&1; then
    name="sing-box"
else
    for f in /var/run/wireguard/*.name; do
        [[ -e $f ]] || continue
        n="${f##*/}"
        name="wg-${n%.name}"
        break
    done
fi
# Nothing up: print nothing, exactly as the old badge did, so the status line
# collapses instead of showing a row of red for a tunnel nobody asked for.
[[ -n "$name" ]] || exit 0

probe() {
    env -u all_proxy -u http_proxy -u https_proxy -u ALL_PROXY -u HTTP_PROXY -u HTTPS_PROXY \
        curl -sS -k -o /dev/null --connect-timeout 2 --max-time 3 "$1" >/dev/null 2>&1
}

probe https://192.168.78.50/ &
p_home=$!
probe https://www.digikala.com/ &
p_iran=$!
probe https://1.1.1.1/ &
p_world=$!

# wait in the main shell: inside $(...) the jobs would not be our children
if wait "$p_home"; then home="🟢"; else home="🔴"; fi
if wait "$p_iran"; then iran="🟢"; else iran="🔴"; fi
if wait "$p_world"; then world="🟢"; else world="🔴"; fi

printf '%s 🏠 %s  🇮🇷 %s  🌍 %s \n' "$name" "$home" "$iran" "$world"
