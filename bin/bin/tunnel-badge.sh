#!/usr/bin/env bash
# tmux status badge for the active home tunnel -- WireGuard OR sing-box -- with
# LIVE reachability checks, so the badge reflects a tunnel that works rather
# than one that merely left a marker file behind.
#
#   sing-box[38.7M] 🏠 🟢  🇮🇷 🟢  🌍 🟢
#     name  the tunnel actually carrying the house right now
#     [..]  last throughput sample from iran-perf.sh, dimmed when stale
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

cache_dir="${IRAN_PERF_CACHE:-$HOME/.cache/iran-perf}"

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

probe https://192.168.78.50/ & p_home=$!
probe https://www.digikala.com/ & p_iran=$!
probe https://1.1.1.1/ & p_world=$!

# wait in the main shell: inside $(...) the jobs would not be our children
if wait "$p_home"; then home="🟢"; else home="🔴"; fi
if wait "$p_iran"; then iran="🟢"; else iran="🔴"; fi
if wait "$p_world"; then world="🟢"; else world="🔴"; fi

# --- last throughput sample ------------------------------------------------
# Read only; measuring here would put a multi-megabyte download behind every
# status-bar refresh.
speed=""
if [[ -r "$cache_dir/current" ]]; then
    # mbits_ts, not the line's own timestamp: most ticks are latency-only and
    # carry the previous throughput figure forward, so ageing it by when the
    # LINE was written would always look fresh.
    IFS=$'\t' read -r _ts _tun _tls _ttfb mbits mbits_ts < "$cache_dir/current" || true
    if [[ -n "${mbits:-}" && "$mbits" != "-" ]]; then
        age=$(( $(date +%s) - ${mbits_ts:-0} ))
        # A number with no indication of its age invites reading a half-hour-old
        # sample as current.
        if ((age < 1800)); then
            speed="[${mbits}M]"
        else
            speed="[${mbits}M?]"
        fi
    fi
fi

printf '%s%s 🏠 %s  🇮🇷 %s  🌍 %s \n' "$name" "$speed" "$home" "$iran" "$world"
