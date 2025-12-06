#!/usr/bin/env bash

usage() {
    echo -n "Provision and harden a Raspberry Pi blackbox for safe internet exposure"
    # shellcheck disable=1004
    echo '
             ╔═══════════════════════════════════════╗
             ║   ┌─────────────────────────────────┐ ║
             ║   │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ ║
             ║   │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ ║
             ║   │ ▓▓▓▓▓  B L A C K B O X  ▓▓▓▓▓▓▓ │ ║
             ║   │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ ║
             ║   │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ ║
             ║   └─────────────────────────────────┘ ║
             ║     ◉ PWR    ◉ ACT    ◉ NET    [🔒]  ║
             ╚═══════════════════════════════════════╝
                    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
               ════╬═══════════════════════╬════
                   ║    D O O R S T E P    ║
               ════╬═══════════════════════╬════
'
}

export dependencies=("env")

SSH_PORT="${SSH_PORT:-22}"
SSH_ALLOWED_USERS="${SSH_ALLOWED_USERS:-$USER}"
FAIL2BAN_BANTIME="${FAIL2BAN_BANTIME:-12h}"
FAIL2BAN_FINDTIME="${FAIL2BAN_FINDTIME:-10m}"
FAIL2BAN_MAXRETRY="${FAIL2BAN_MAXRETRY:-4}"
WATCHDOG_TIMEOUT="${WATCHDOG_TIMEOUT:-15}"
COCKPIT_PORT="${COCKPIT_PORT:-9090}"
COCKPIT_ALLOWED_NETWORKS="${COCKPIT_ALLOWED_NETWORKS:-192.168.0.0/16}"

main_apt() {
    if ! sudo apt update -yq; then
        msg "failed to refresh apt package list" "error"
        return 1
    fi

    local packages=(
        openssh-server
        ufw
        fail2ban
        unattended-upgrades
        needrestart
        logwatch
        debsums
        auditd
        vnstat
        sysstat
        net-tools
        watchdog
        cockpit
    )

    require_apt "${packages[@]}"
}

main() {
    if ! validate_port "${SSH_PORT}"; then
        return 1
    fi

    if [[ -z "${SSH_ALLOWED_USERS// /}" ]]; then
        msg "SSH_ALLOWED_USERS must not be empty" "error"
        return 1
    fi

    update_system
    configure_timesync
    configure_journal
    configure_sysctl
    configure_ssh
    configure_fail2ban
    configure_unattended_upgrades
    configure_watchdog
    configure_cockpit
    configure_ufw
    enable_services
    configure_motd

    msg "Raspberry Pi blackbox hardening complete" "success"
    msg "SSH listening on ${SSH_PORT}/tcp for: ${SSH_ALLOWED_USERS}" "info"
    msg "Cockpit available at https://$(hostname):${COCKPIT_PORT} from ${COCKPIT_ALLOWED_NETWORKS}" "info"
    msg "Watchdog enabled with ${WATCHDOG_TIMEOUT}s timeout, monitoring sshd" "info"
}

is_valid_port() {
    local port=$1
    [[ "${port}" =~ ^[0-9]+$ ]] && ((port >= 1 && port <= 65535))
}

validate_port() {
    local port=$1
    if ! is_valid_port "${port}"; then
        msg "invalid SSH_PORT '${port}', must be between 1-65535" "error"
        return 1
    fi
}

update_system() {
    msg "upgrading base system packages"
    if ! sudo apt -qy full-upgrade; then
        msg "failed to upgrade packages" "error"
        return 1
    fi

    sudo apt -qy autoremove --purge
    sudo apt -qy clean
}

configure_timesync() {
    msg "enabling secure time synchronization"
    if ! sudo timedatectl set-ntp true; then
        msg "failed to enable NTP via timedatectl" "warn"
    fi

    if ! sudo systemctl enable --now systemd-timesyncd.service; then
        msg "failed to enable systemd-timesyncd" "warn"
    fi
}

configure_journal() {
    msg "configuring persistent journal storage"
    local conf_dir="/etc/systemd/journald.conf.d"
    local conf_file="${conf_dir}/99-persistent.conf"

    if ! sudo mkdir -p "${conf_dir}"; then
        msg "failed to create ${conf_dir}" "error"
        return 1
    fi

    sudo tee "${conf_file}" >/dev/null <<'EOF'
[Journal]
Storage=persistent
SystemMaxUse=200M
Compress=yes
ForwardToSyslog=yes
EOF

    if ! sudo systemctl restart systemd-journald.service; then
        msg "failed to restart systemd-journald" "warn"
    fi
}

configure_sysctl() {
    msg "applying kernel network hardening"
    local conf_file="/etc/sysctl.d/99-blackbox-hardening.conf"

    sudo tee "${conf_file}" >/dev/null <<'EOF'
# Restrict spoofing, redirects, and source routing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# TCP hardening
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_max_syn_backlog = 4096

# Misc protections
kernel.randomize_va_space = 2
kernel.kptr_restrict = 1
kernel.dmesg_restrict = 1
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
kernel.unprivileged_bpf_disabled = 1
EOF

    if ! sudo sysctl --system >/dev/null; then
        msg "failed to reload sysctl settings" "warn"
    fi
}

configure_ssh() {
    msg "configuring SSH hardening"
    local conf_dir="/etc/ssh/sshd_config.d"
    local conf_file="${conf_dir}/10-internet-hardening.conf"

    if ! sudo mkdir -p "${conf_dir}"; then
        msg "failed to create ${conf_dir}" "error"
        return 1
    fi

    sudo tee "${conf_file}" >/dev/null <<EOF
Port ${SSH_PORT}
Protocol 2
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
KbdInteractiveAuthentication no
UsePAM yes
AllowUsers ${SSH_ALLOWED_USERS}
PermitEmptyPasswords no
AllowAgentForwarding no
AllowTcpForwarding yes
X11Forwarding no
ClientAliveInterval 240
ClientAliveCountMax 2
LoginGraceTime 30
MaxAuthTries 3
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
Subsystem sftp internal-sftp
EOF

    if ! sudo sshd -t; then
        msg "ssh configuration validation failed" "error"
        return 1
    fi

    if ! sudo systemctl reload sshd.service; then
        msg "failed to reload sshd" "error"
        return 1
    fi
}

configure_fail2ban() {
    msg "configuring fail2ban for SSH protection"
    local jail_dir="/etc/fail2ban/jail.d"
    local jail_file="${jail_dir}/10-sshd.conf"

    if ! sudo mkdir -p "${jail_dir}"; then
        msg "failed to create ${jail_dir}" "error"
        return 1
    fi

    sudo tee "${jail_file}" >/dev/null <<EOF
[sshd]
enabled = true
backend = systemd
mode = aggressive
port = ${SSH_PORT}
maxretry = ${FAIL2BAN_MAXRETRY}
findtime = ${FAIL2BAN_FINDTIME}
bantime = ${FAIL2BAN_BANTIME}
banaction = ufw
EOF

    if ! sudo systemctl enable --now fail2ban.service; then
        msg "failed to enable fail2ban" "error"
        return 1
    fi
}

configure_unattended_upgrades() {
    msg "configuring unattended upgrades with automatic reboots"

    sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

    sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-hardening >/dev/null <<'EOF'
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:45";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Mail "root";
Unattended-Upgrade::MailOnlyOnError "true";
EOF

    if ! sudo systemctl enable --now unattended-upgrades.service; then
        msg "failed to enable unattended-upgrades" "warn"
    fi
}

configure_watchdog() {
    msg "configuring hardware watchdog for automatic recovery"

    # Enable bcm2835 watchdog module on Raspberry Pi
    if ! grep -q "^bcm2835_wdt" /etc/modules 2>/dev/null; then
        echo "bcm2835_wdt" | sudo tee -a /etc/modules >/dev/null
    fi

    # Load the module now
    if ! sudo modprobe bcm2835_wdt 2>/dev/null; then
        msg "bcm2835_wdt module not available (may not be a Raspberry Pi)" "warn"
    fi

    local conf_file="/etc/watchdog.conf"

    sudo tee "${conf_file}" >/dev/null <<EOF
# Hardware watchdog device
watchdog-device = /dev/watchdog
watchdog-timeout = ${WATCHDOG_TIMEOUT}

# Reboot if system is unresponsive
realtime = yes
priority = 1

# Check if system load is too high (5x number of CPUs for 1-min average)
max-load-1 = 24

# Check memory usage (pages)
min-memory = 1

# Check if critical processes are running
pidfile = /run/sshd.pid

# Check network connectivity (ping test)
ping = 127.0.0.1

# Log watchdog activity
log-dir = /var/log/watchdog

# Interval between checks (seconds)
interval = 10

# Retry count before action
retry-timeout = 60

# Actions on failure
admin = root
EOF

    # Create log directory
    sudo mkdir -p /var/log/watchdog

    if ! sudo systemctl enable --now watchdog.service; then
        msg "failed to enable watchdog service" "error"
        return 1
    fi

    msg "watchdog configured with ${WATCHDOG_TIMEOUT}s timeout, monitoring sshd" "success"
}

configure_cockpit() {
    msg "configuring Cockpit web console for local network access"

    local conf_dir="/etc/cockpit"
    local conf_file="${conf_dir}/cockpit.conf"

    if ! sudo mkdir -p "${conf_dir}"; then
        msg "failed to create ${conf_dir}" "error"
        return 1
    fi

    sudo tee "${conf_file}" >/dev/null <<EOF
[WebService]
Origins = https://${HOSTNAME}:${COCKPIT_PORT}
ProtocolHeader = X-Forwarded-Proto
AllowUnencrypted = false

[Session]
IdleTimeout = 15
EOF

    if ! sudo systemctl enable --now cockpit.socket; then
        msg "failed to enable cockpit" "error"
        return 1
    fi

    msg "Cockpit enabled on port ${COCKPIT_PORT} (local network only)" "success"
}

configure_ufw() {
    msg "configuring firewall rules via ufw"

    if ! sudo ufw default deny incoming; then
        msg "failed to set ufw default incoming policy" "error"
        return 1
    fi

    sudo ufw default allow outgoing
    sudo ufw logging medium
    sudo ufw delete allow "${SSH_PORT}/tcp" &>/dev/null || true
    sudo ufw limit "${SSH_PORT}/tcp"

    # Allow Cockpit only from local networks
    sudo ufw delete allow "${COCKPIT_PORT}/tcp" &>/dev/null || true
    read -r -a cockpit_networks <<<"${COCKPIT_ALLOWED_NETWORKS}" || true
    for network in "${cockpit_networks[@]}"; do
        if [[ -n "${network}" ]]; then
            sudo ufw allow from "${network}" to any port "${COCKPIT_PORT}" proto tcp
            msg "Cockpit allowed from ${network}" "info"
        fi
    done

    read -r -a tcp_ports <<<"${ADDITIONAL_TCP_PORTS:-}" || true
    for port in "${tcp_ports[@]}"; do
        if is_valid_port "${port}"; then
            sudo ufw allow "${port}/tcp"
        elif [[ -n "${port}" ]]; then
            msg "skipping invalid TCP port '${port}'" "warn"
        fi
    done

    read -r -a udp_ports <<<"${ADDITIONAL_UDP_PORTS:-}" || true
    for port in "${udp_ports[@]}"; do
        if is_valid_port "${port}"; then
            sudo ufw allow "${port}/udp"
        elif [[ -n "${port}" ]]; then
            msg "skipping invalid UDP port '${port}'" "warn"
        fi
    done

    if ! sudo ufw --force enable; then
        msg "failed to enable ufw" "error"
        return 1
    fi
}

enable_services() {
    msg "enabling monitoring and auditing services"
    local services=(
        ufw.service
        systemd-timesyncd.service
        unattended-upgrades.service
        auditd.service
        vnstat.service
    )

    for service in "${services[@]}"; do
        if ! sudo systemctl enable --now "${service}"; then
            msg "failed to enable ${service}" "warn"
        fi
    done
}

configure_motd() {
    msg "installing dynamic MOTD script"
    local motd_dir="/etc/update-motd.d"
    local motd_script="${motd_dir}/20-blackbox-status"

    if ! sudo mkdir -p "${motd_dir}"; then
        msg "failed to create ${motd_dir}" "error"
        return 1
    fi

    sudo tee "${motd_script}" >/dev/null <<'MOTD_EOF'
#!/bin/bash
# Blackbox MOTD generator (run by pam_motd/update-motd)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

cat <<'EOF'

    ╔═══════════════════════════════════╗
    ║  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ║
    ║  ▓▓▓  B L A C K B O X  ▓▓▓▓▓▓▓▓▓  ║
    ║  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ║
    ╚═══════════════════════════════════╝
       Secure. Hardened. Watching.

EOF

echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Welcome to $(hostname) [BLACKBOX]${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}▸ Uptime:${NC}    $(uptime -p)"
echo -e "${YELLOW}▸ Load:${NC}      $(awk '{print $1, $2, $3}' /proc/loadavg)"

MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
if [[ -n "${MEM_TOTAL}" && "${MEM_TOTAL}" -ne 0 ]]; then
    MEM_PCT=$((MEM_USED * 100 / MEM_TOTAL))
    echo -e "${YELLOW}▸ Memory:${NC}    ${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PCT}%)"
fi
echo -e "${YELLOW}▸ Disk /:${NC}    $(df -h / | awk 'NR==2 {print $5}') used"

if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
    echo -e "${YELLOW}▸ CPU Temp:${NC}  $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))°C"
fi

FAILED=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
if [[ "${FAILED}" -gt 0 ]]; then
    echo -e "${RED}▸ ALERT:${NC}     ${FAILED} failed service(s)!"
fi

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
MOTD_EOF

    sudo chmod +x "${motd_script}"

    if ! echo "${motd_script}" | sudo tee /etc/motd; then
        msg "failed to write fallback /etc/motd" "warn"
    fi
}
