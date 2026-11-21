#!/usr/bin/env bash
# tmux status badge for the Snapp DC VPN (Cisco Secure Client, driven by the
# snapp-vpn function from the keys repo, bash/aliases/snapp.sh).
#
#   🚕 🟢   the tunnel is up and gitlab.snapp.ir answers
#   🚕 🟡   the tunnel is up but nothing answers yet: still in the ISE
#              quarantine (posture takes ~30-45 s after connect), or posture
#              failed (Bitdefender not running)
#   (nothing)  no tunnel
#
# The taxi stands for Snapp. Like the other symbols here it is one codepoint
# that terminals draw two cells wide, so the right-aligned line does not wrap
# (see tunnel-badge.sh for what a two-codepoint flag does).
#
# The tunnel test reads the routing table, not `vpn state`: the Cisco CLI takes
# about 2.5 s to answer, and netstat needs no root and returns at once. The
# gateway pushes 172.16/12 through its utun interface; nothing else here routes
# that range. A route alone is not access, because at "Connected" the ISE ACL
# lets DNS through and nothing more, so the badge also probes a real host.
set -u

probe_host=${SNAPP_VPN_PROBE:-172.20.2.199}
probe_port=${SNAPP_VPN_PROBE_PORT:-443}

netstat -rnf inet 2>/dev/null | awk '$1 == "172.16/12" && $NF ~ /^utun/ {found = 1} END {exit !found}' || exit 0

if nc -z -G 2 -w 2 "$probe_host" "$probe_port" >/dev/null 2>&1; then
    printf '🚕 🟢 \n'
else
    printf '🚕 🟡 \n'
fi
