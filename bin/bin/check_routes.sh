#!/usr/bin/env bash
# check_routes.sh — Test which protocols/ports are reachable from Iran
# during international route shutdowns.
#
# Usage: ./check_routes.sh [--json] [--targets targets.conf]
#
# Requires: bash 4+, python3, ping, nc (netcat), curl
# Run as root for ICMP tests if ping requires it.

set -uo pipefail

# ─── Defaults ────────────────────────────────────────────────────────────────

TIMEOUT=3   # seconds per probe
PARALLEL=10 # max concurrent probes
JSON_OUTPUT=false
TARGETS_FILE=""
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Colors (disabled if not a terminal)
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    GREEN=''
    RED=''
    YELLOW=''
    CYAN=''
    BOLD=''
    RESET=''
fi

# ─── Target IPs & Ports ─────────────────────────────────────────────────────

# International targets (commonly blocked during shutdowns)
INTL_IPS=(
    "8.8.8.8"        # Google DNS
    "8.8.4.4"        # Google DNS secondary
    "1.1.1.1"        # Cloudflare DNS
    "1.0.0.1"        # Cloudflare DNS secondary
    "9.9.9.9"        # Quad9 DNS
    "208.67.222.222" # OpenDNS
    "4.2.2.4"        # Level3 DNS
    "185.228.168.9"  # CleanBrowsing
    "76.76.2.0"      # Control D
    "94.140.14.14"   # AdGuard DNS
)

# Domestic targets (should remain reachable)
DOMESTIC_IPS=(
    "178.22.122.100" # Shecan DNS
    "185.51.200.2"   # Shecan DNS secondary
    "10.202.10.10"   # Radar/403 DNS
    "10.202.10.11"   # Radar/403 DNS secondary
)

# Domestic hostnames for HTTP checks
DOMESTIC_HOSTS=(
    "digikala.com"
    "snapp.ir"
    "divar.ir"
    "shaparak.ir"
)

# International hostnames for HTTP checks
INTL_HOSTS=(
    "www.google.com"
    "www.cloudflare.com"
    "api.github.com"
    "www.wikipedia.org"
)

TCP_PORTS=(22 53 80 443 853 8080 8443)
UDP_PORTS=(53 443 51820)

# ─── Argument Parsing ────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
    case "$1" in
    --json)
        JSON_OUTPUT=true
        shift
        ;;
    --targets)
        TARGETS_FILE="$2"
        shift 2
        ;;
    --timeout)
        TIMEOUT="$2"
        shift 2
        ;;
    -h | --help)
        echo "Usage: $0 [--json] [--targets file] [--timeout secs]"
        echo ""
        echo "  --json       Output results as JSON"
        echo "  --targets    Load extra target IPs from file (one per line)"
        echo "  --timeout    Timeout per probe in seconds (default: 3)"
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Load extra targets from file if provided
if [[ -n "$TARGETS_FILE" && -f "$TARGETS_FILE" ]]; then
    while IFS= read -r line; do
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        INTL_IPS+=("$line")
    done <"$TARGETS_FILE"
fi

# ─── Result Storage ──────────────────────────────────────────────────────────

RESULTS_DIR=$(mktemp -d)
trap 'rm -rf "$RESULTS_DIR"' EXIT

record_result() {
    local category="$1" proto="$2" target="$3" port="$4" status="$5" latency="$6"
    echo "${category}|${proto}|${target}|${port}|${status}|${latency}" \
        >"${RESULTS_DIR}/result_${category}_${proto}_${target}_${port}_$$_${RANDOM}"
}

# ─── Probe Functions ─────────────────────────────────────────────────────────

probe_icmp() {
    local ip="$1" category="$2"
    local output ms
    output=$(ping -c 2 -W "$TIMEOUT" "$ip" 2>&1) || true
    if echo "$output" | grep -q "bytes from"; then
        ms=$(echo "$output" | grep -oP 'time=\K[0-9.]+' | tail -1) || ms="?"
        record_result "$category" "ICMP" "$ip" "-" "OK" "${ms}ms"
    else
        record_result "$category" "ICMP" "$ip" "-" "FAIL" "-"
    fi
}

probe_tcp() {
    local ip="$1" port="$2" category="$3"
    local start end ms
    start=$(date +%s%N 2>/dev/null || python3 -c "import time; print(int(time.time()*1e9))")
    if timeout "$TIMEOUT" bash -c "echo >/dev/tcp/$ip/$port" 2>/dev/null; then
        end=$(date +%s%N 2>/dev/null || python3 -c "import time; print(int(time.time()*1e9))")
        ms=$(((end - start) / 1000000)) || true
        record_result "$category" "TCP" "$ip" "$port" "OK" "${ms}ms"
    else
        record_result "$category" "TCP" "$ip" "$port" "FAIL" "-"
    fi
}

probe_udp_dns() {
    local ip="$1" port="${2:-53}" category="$3"
    local result
    result=$(python3 -c "
import socket, struct, time
qname = b'\\x06google\\x03com\\x00'
header = struct.pack('>HHHHHH', 0x1234, 0x0100, 1, 0, 0, 0)
query = header + qname + struct.pack('>HH', 1, 1)
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout($TIMEOUT)
    t0 = time.monotonic()
    s.sendto(query, ('$ip', $port))
    data, _ = s.recvfrom(512)
    ms = (time.monotonic() - t0) * 1000
    print(f'OK|{ms:.1f}ms')
except Exception:
    print('FAIL|-')
finally:
    s.close()
" 2>/dev/null || echo "FAIL|-")
    local status latency
    status="${result%%|*}"
    latency="${result##*|}"
    record_result "$category" "UDP" "$ip" "$port" "$status" "$latency"
}

probe_http() {
    local host="$1" category="$2"
    local code time_total
    read -r code time_total < <(
        curl -so /dev/null \
            -w "%{http_code} %{time_total}" \
            --connect-timeout "$TIMEOUT" \
            --max-time $((TIMEOUT * 2)) \
            "https://${host}/" 2>/dev/null || echo "000 0"
    )
    if [[ "$code" != "000" ]]; then
        record_result "$category" "HTTPS" "$host" "443" "OK($code)" "${time_total}s"
    else
        record_result "$category" "HTTPS" "$host" "443" "FAIL" "-"
    fi
}

# ─── Parallel Execution Helper ───────────────────────────────────────────────

job_count=0

run_probe() {
    "$@" &
    ((job_count++))
    if ((job_count >= PARALLEL)); then
        wait -n 2>/dev/null || wait
        ((job_count--))
    fi
}

wait_all() {
    wait
    job_count=0
}

# ─── Main ────────────────────────────────────────────────────────────────────

if ! $JSON_OUTPUT; then
    echo -e "${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}║        Network Protocol Reachability Checker             ║${RESET}"
    echo -e "${BOLD}║        Timestamp: ${TIMESTAMP}                   ║${RESET}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
fi

# --- ICMP ---
if ! $JSON_OUTPUT; then
    echo -e "${CYAN}[1/6] Testing ICMP (ping)...${RESET}"
fi
for ip in "${INTL_IPS[@]}"; do run_probe probe_icmp "$ip" "international"; done
for ip in "${DOMESTIC_IPS[@]}"; do run_probe probe_icmp "$ip" "domestic"; done
wait_all

# --- TCP ---
if ! $JSON_OUTPUT; then
    echo -e "${CYAN}[2/6] Testing TCP ports...${RESET}"
fi
for ip in "${INTL_IPS[@]}"; do
    for port in "${TCP_PORTS[@]}"; do
        run_probe probe_tcp "$ip" "$port" "international"
    done
done
for ip in "${DOMESTIC_IPS[@]}"; do
    for port in 53 80 443; do
        run_probe probe_tcp "$ip" "$port" "domestic"
    done
done
wait_all

# --- UDP DNS ---
if ! $JSON_OUTPUT; then
    echo -e "${CYAN}[3/6] Testing UDP (DNS query on port 53)...${RESET}"
fi
for ip in "${INTL_IPS[@]}"; do run_probe probe_udp_dns "$ip" 53 "international"; done
for ip in "${DOMESTIC_IPS[@]}"; do run_probe probe_udp_dns "$ip" 53 "domestic"; done
wait_all

# --- HTTPS international ---
if ! $JSON_OUTPUT; then
    echo -e "${CYAN}[4/6] Testing HTTPS to international hosts...${RESET}"
fi
for host in "${INTL_HOSTS[@]}"; do run_probe probe_http "$host" "international"; done
wait_all

# --- HTTPS domestic ---
if ! $JSON_OUTPUT; then
    echo -e "${CYAN}[5/6] Testing HTTPS to domestic hosts...${RESET}"
fi
for host in "${DOMESTIC_HOSTS[@]}"; do run_probe probe_http "$host" "domestic"; done
wait_all

# --- DNS resolution ---
if ! $JSON_OUTPUT; then
    echo -e "${CYAN}[6/6] Testing DNS resolution via system resolver...${RESET}"
fi
for host in google.com cloudflare.com github.com digikala.com; do
    (
        result=$(python3 -c "
import socket, time
try:
    t0 = time.monotonic()
    r = socket.getaddrinfo('$host', 80)
    ms = (time.monotonic() - t0) * 1000
    print(f'OK({r[0][4][0]})|{ms:.1f}ms')
except Exception:
    print('FAIL|-')
" 2>/dev/null || echo "FAIL|-")
        status="${result%%|*}"
        latency="${result##*|}"
        record_result "dns" "RESOLVE" "$host" "-" "$status" "$latency"
    ) &
done
wait_all

# ─── Collect & Display Results ───────────────────────────────────────────────

declare -a ALL_RESULTS=()
for f in "$RESULTS_DIR"/result_*; do
    [[ -f "$f" ]] && ALL_RESULTS+=("$(cat "$f")")
done

if $JSON_OUTPUT; then
    # JSON output
    echo "{"
    echo "  \"timestamp\": \"$TIMESTAMP\","
    echo "  \"results\": ["
    first=true
    for r in "${ALL_RESULTS[@]}"; do
        IFS='|' read -r category proto target port status latency <<<"$r"
        $first || echo ","
        printf '    {"category":"%s","protocol":"%s","target":"%s","port":"%s","status":"%s","latency":"%s"}' \
            "$category" "$proto" "$target" "$port" "$status" "$latency"
        first=false
    done
    echo ""
    echo "  ]"
    echo "}"
else
    # Pretty table output
    echo ""

    for section in "international" "domestic" "dns"; do
        case "$section" in
        international) echo -e "${BOLD}━━━ International Routes ━━━${RESET}" ;;
        domestic) echo -e "${BOLD}━━━ Domestic Routes ━━━${RESET}" ;;
        dns) echo -e "${BOLD}━━━ DNS Resolution (system resolver) ━━━${RESET}" ;;
        esac

        printf "  ${BOLD}%-10s %-22s %-8s %-12s %s${RESET}\n" \
            "PROTO" "TARGET" "PORT" "STATUS" "LATENCY"
        printf "  %-10s %-22s %-8s %-12s %s\n" \
            "─────" "──────" "────" "──────" "───────"

        for r in "${ALL_RESULTS[@]}"; do
            IFS='|' read -r category proto target port status latency <<<"$r"
            [[ "$category" != "$section" ]] && continue

            local_status_color="$RED"
            [[ "$status" == OK* ]] && local_status_color="$GREEN"

            printf "  %-10s %-22s %-8s ${local_status_color}%-12s${RESET} %s\n" \
                "$proto" "$target" "$port" "$status" "$latency"
        done
        echo ""
    done

    # Summary
    total=${#ALL_RESULTS[@]}
    ok=0
    fail=0
    for r in "${ALL_RESULTS[@]}"; do
        IFS='|' read -r _ _ _ _ status _ <<<"$r"
        [[ "$status" == OK* ]] && ((ok++)) || ((fail++))
    done

    echo -e "${BOLD}━━━ Summary ━━━${RESET}"
    echo -e "  Total probes: ${total}"
    echo -e "  ${GREEN}Reachable:  ${ok}${RESET}"
    echo -e "  ${RED}Blocked:    ${fail}${RESET}"
    echo ""
fi
