#!/usr/bin/env bash
# iran-perf — sample the performance of the home (Iran) tunnel and cache it.
#
# Written for the tmux badge (tunnel-badge.sh) to read, and to build a history
# worth looking at when "the connection feels slow" needs a better answer than
# a feeling. Two outputs under $cache_dir:
#
#   current      one line for the badge: epoch, tunnel, tls_ms, ttfb_ms,
#                mbits, mbits_epoch -- where mbits is the last throughput
#                figure KNOWN, not necessarily one taken this tick, and
#                mbits_epoch says when it was taken so the badge can age it
#   history.tsv  append-only: epoch, tunnel, tls_ms, ttfb_ms, mbits
#
# Usage:  iran-perf.sh            latency only
#         iran-perf.sh --full     also sample throughput, unconditionally
#         iran-perf.sh --auto     sample throughput only if the last one has
#                                 aged out (what launchd runs)
#
# --auto exists because the two measurements have very different costs. Latency
# is two round trips; a throughput sample is $sample_secs of real download, so
# taking one every five minutes would push a couple of hundred MB a day through
# the tunnel purely to draw a status bar. Latency every tick, throughput hourly.
#
# ---------------------------------------------------------------------------
# Why there is no ping here, which is the obvious thing to reach for:
#
# ICMP is MEANINGLESS through the sing-box TUN. Its gvisor stack answers echo
# requests for routed addresses itself instead of forwarding them, so pinging
# the home router at 192.168.78.254 returns ~0.4 ms -- a number that looks
# excellent and describes nothing, since Germany to Iran cannot be under 80 ms.
# A latency graph built on it would have been confidently, invisibly wrong.
#
# TCP connect time is no better, for the same reason: the TUN completes the
# handshake locally, so curl reports ~2 ms for a host 80 ms away.
#
# The TLS handshake (curl's time_appconnect) is the first thing that cannot be
# faked locally -- it needs real round trips to the real server -- so that is
# what is recorded, along with time-to-first-byte. Both work identically for
# WireGuard and for sing-box.
#
# Why throughput and not just latency: the Zi-tel international egress fails by
# LOSS, not by narrowing. A path that connects fast can still deliver
# 0.35 Mbit/s once loss has collapsed the sender's congestion window -- which is
# exactly what was happening before blackbox moved to BBR. Latency alone shows
# nothing wrong.
# ---------------------------------------------------------------------------
set -u

cache_dir="${IRAN_PERF_CACHE:-$HOME/.cache/iran-perf}"
mkdir -p "$cache_dir"
current="$cache_dir/current"
history="$cache_dir/history.tsv"

# Deliberately Iranian hosts, reached the way real traffic is -- through
# whatever tunnel is up. A foreign target would measure the local uplink.
latency_url="https://mirror.arvancloud.ir/"
probe_url="https://mirror.arvancloud.ir/ubuntu/ls-lR.gz"
sample_secs="${IRAN_PERF_SECS:-4}"

# curl must never see the shell's proxy variables: with all_proxy set it
# reports the PROXY's connectivity, a confident wrong answer.
clean_env=(env -u all_proxy -u ALL_PROXY -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY)

# --- which tunnel is carrying the house right now --------------------------
tunnel="none"
if pgrep -f "sing-box run -c .*tun.json" >/dev/null 2>&1; then
    tunnel="sing-box"
else
    for f in /var/run/wireguard/*.name; do
        [[ -e $f ]] || continue
        n="${f##*/}"
        tunnel="wg-${n%.name}"
        break
    done
fi

# --- TLS-handshake + first-byte latency to an Iranian host -----------------
tls_ms="-"
ttfb_ms="-"
if timings="$("${clean_env[@]}" curl -o /dev/null -s --max-time 15 \
        -w '%{time_appconnect} %{time_starttransfer}' "$latency_url" 2>/dev/null)"; then
    tls_ms="$(awk '{printf "%.0f", $1*1000}' <<<"$timings")"
    ttfb_ms="$(awk '{printf "%.0f", $2*1000}' <<<"$timings")"
fi
# A zero appconnect means the handshake never happened (request failed), not
# that it was instant.
[[ -z "$tls_ms" || "$tls_ms" == "0" ]] && tls_ms="-"
[[ -z "$ttfb_ms" || "$ttfb_ms" == "0" ]] && ttfb_ms="-"

# --- throughput, only when asked ------------------------------------------
# Skipped by default: a sample costs sample_secs of real download, so running it
# on every tick would push tens of MB an hour through the tunnel just to draw a
# status bar.
# --auto: take a throughput sample only when the cached one has aged out.
want_full=false
case "${1:-}" in
    --full) want_full=true ;;
    --auto)
        full_every="${IRAN_PERF_FULL_INTERVAL:-3600}"
        last_full=0
        if [[ -r "$history" ]]; then
            last_full="$(awk -F'\t' '$5 != "-" && $5 != "" {t=$1} END{print t+0}' "$history")"
        fi
        (( $(date +%s) - last_full >= full_every )) && want_full=true
        ;;
esac

mbits="-"
if [[ "$want_full" == true ]]; then
    # %{speed_download} is curl's own average over the transfer. Computing
    # bytes/sample_secs by hand is wrong whenever the transfer ends early --
    # it then divides by more time than actually elapsed.
    # No `|| echo` fallback here, and the format ends in \n on purpose. curl's
    # -w output carries no trailing newline, so a fallback appended on failure
    # lands on the SAME line and silently corrupts the field it is meant to
    # replace -- it read "speed 2061103" + "0 0" as a 206 GB download.
    # Exit 28 is also the EXPECTED outcome here: --max-time truncating the
    # transfer is how the sample is bounded, not an error.
    sp=0
    sz=0
    read -r sp sz < <("${clean_env[@]}" curl -o /dev/null --max-time "$sample_secs" -s \
        -w '%{speed_download} %{size_download}\n' "$probe_url" 2>/dev/null)
    # Two sanity gates, both learned the hard way -- an un-gated sample
    # reported 490 Mbit/s on a link whose ceiling is about 50.
    #   - under 2 MB the transfer was too short to average meaningfully
    #     (a redirect or error body divided by a few ms reads as enormous)
    #   - over 200 Mbit/s is not physically reachable over this path, so it is
    #     a measurement artefact, and publishing "-" beats publishing fiction
    if [[ "${sz:-0}" =~ ^[0-9]+$ ]] && ((sz > 2000000)); then
        mbits="$(awk -v s="${sp:-0}" 'BEGIN{printf "%.1f", s*8/1000000}')"
        awk -v m="$mbits" 'BEGIN{exit !(m > 200)}' && mbits="-"
    fi
fi

now="$(date +%s)"
printf '%s\t%s\t%s\t%s\t%s\n' "$now" "$tunnel" "$tls_ms" "$ttfb_ms" "$mbits" >> "$history"

# The badge needs a throughput figure on every tick, but most ticks are latency
# only. Writing "-" into current on those would blank the number between hourly
# samples, so carry the last KNOWN one forward together with its own timestamp
# -- the badge marks it stale rather than showing a fresh-looking lie.
mbits_shown="$mbits"
mbits_ts="$now"
if [[ "$mbits" == "-" ]]; then
    read -r mbits_ts mbits_shown < <(
        awk -F'\t' '$5 != "-" && $5 != "" {t=$1; v=$5} END{if (v=="") {print 0, "-"} else {print t, v}}' "$history"
    )
fi
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$now" "$tunnel" "$tls_ms" "$ttfb_ms" "$mbits_shown" "$mbits_ts" > "$current"

# Keep history bounded -- roughly a month at one sample every five minutes.
if [[ -f "$history" ]] && (($(wc -l < "$history") > 10000)); then
    tail -8000 "$history" > "$history.tmp" && mv "$history.tmp" "$history"
fi

printf 'tunnel=%s tls=%sms ttfb=%sms throughput=%s Mbit/s\n' \
    "$tunnel" "$tls_ms" "$ttfb_ms" "$mbits"
