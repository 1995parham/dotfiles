#!/usr/bin/env bash

usage() {
    echo "provision and harden an arch linux server with security controls"

    # shellcheck disable=1004,2016
    printf '
                                      ___
 ___  ___ _ ____   _____ _ __  __  __/ _ \
/ __|/ _ \ |__\ \ / / _ \ |__| \ \/ / | | |
\__ \  __/ |   \ V /  __/ |     >  <| |_| |
|___/\___|_|    \_/ \___|_|    /_/\_\\___/

    .--.      "Who goes there?!"
   |o_o |
   |:_/ |     Im watching the logs...
  //   \ \    and I have FIREWALL!
 (|     | )
/\\_   _/`\
\___)=(___/
    '
}

export dependencies=("pacman" "yay" "env")

SSH_PORT="${SSH_PORT:-22}"
SSH_ALLOWED_USERS="${SSH_ALLOWED_USERS:-$USER}"
SSH_ALLOWED_SUBNET="${SSH_ALLOWED_SUBNET:-192.168.0.0/16}"
FAIL2BAN_BANTIME="${FAIL2BAN_BANTIME:-12h}"
FAIL2BAN_FINDTIME="${FAIL2BAN_FINDTIME:-10m}"
FAIL2BAN_MAXRETRY="${FAIL2BAN_MAXRETRY:-4}"

main_pacman() {
    msg "installing security and monitoring packages"
    require_pacman \
        openssh \
        ufw \
        fail2ban \
        arch-audit \
        smartmontools \
        lm_sensors \
        sysstat \
        iotop \
        logrotate \
        cronie \
        nvme-cli
}

main() {
    if ! validate_port "${SSH_PORT}"; then
        return 1
    fi

    if [[ -z "${SSH_ALLOWED_USERS// /}" ]]; then
        msg "SSH_ALLOWED_USERS must not be empty" "error"
        return 1
    fi

    if [[ -n "${SSH_ALLOWED_SUBNET}" ]] && ! is_valid_cidr "${SSH_ALLOWED_SUBNET}"; then
        msg "SSH_ALLOWED_SUBNET '${SSH_ALLOWED_SUBNET}' is not a valid CIDR" "error"
        return 1
    fi

    update_system
    configure_timesync
    configure_journal
    configure_sysctl
    configure_ssh
    configure_fail2ban
    configure_ufw
    enable_services
    configure_lid_switch
    configure_motd
    remind_sensors
    show_security_audit

    msg "server provisioning complete" "success"
    msg "SSH listening on ${SSH_PORT}/tcp for: ${SSH_ALLOWED_USERS}" "info"
    if [[ -n "${SSH_ALLOWED_SUBNET}" ]]; then
        msg "SSH restricted to subnet ${SSH_ALLOWED_SUBNET}" "info"
        if [[ -z "${RESTRICT_SUBNET_PORTS}" ]]; then
            msg "all ports (TCP/UDP) allowed from ${SSH_ALLOWED_SUBNET}" "info"
        fi
    fi
    msg "next steps:" "notice"
    msg "  - ./start.sh keys <github-username>  # add SSH keys"
    msg "  - ./start.sh docker                  # add Docker"
    msg "  - ./start.sh k3s                     # add Kubernetes"
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

is_valid_cidr() {
    local cidr=$1 mask ip o1 o2 o3 o4
    if [[ "${cidr}" == *:* ]]; then
        [[ "${cidr}" =~ ^[0-9A-Fa-f:]+/([0-9]{1,3})$ ]] || return 1
        mask=${BASH_REMATCH[1]}
        ((mask >= 0 && mask <= 128))
        return $?
    fi

    [[ "${cidr}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]{1,2})$ ]] || return 1
    mask=${BASH_REMATCH[2]}
    ip=${cidr%/*}
    IFS='.' read -r o1 o2 o3 o4 <<<"${ip}"
    for octet in "${o1}" "${o2}" "${o3}" "${o4}"; do
        [[ "${octet}" =~ ^[0-9]+$ ]] || return 1
        ((octet >= 0 && octet <= 255)) || return 1
    done
    ((mask >= 0 && mask <= 32))
}

update_system() {
    msg "upgrading base system packages"
    if ! sudo pacman -Syu --noconfirm; then
        msg "failed to upgrade packages" "error"
        return 1
    fi
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
    local conf_file="/etc/sysctl.d/99-server-hardening.conf"

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
AllowTcpForwarding no
X11Forwarding no
ClientAliveInterval 240
ClientAliveCountMax 2
LoginGraceTime 30
MaxAuthTries 3
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
Subsystem sftp internal-sftp
EOF

    if [[ -n "${SSH_ALLOWED_SUBNET}" ]]; then
        local match_pattern
        if [[ "${SSH_ALLOWED_SUBNET}" == *:* ]]; then
            match_pattern="::/0,!${SSH_ALLOWED_SUBNET}"
        else
            match_pattern="0.0.0.0/0,!${SSH_ALLOWED_SUBNET}"
        fi

        {
            echo
            echo "# Deny SSH users outside the allowed subnet"
            echo "Match Address ${match_pattern}"
            echo "    DenyUsers ${SSH_ALLOWED_USERS}"
        } | sudo tee -a "${conf_file}" >/dev/null
    fi

    if ! sudo sshd -t; then
        msg "ssh configuration validation failed" "error"
        return 1
    fi

    if ! sudo systemctl enable --now sshd.service; then
        msg "failed to enable sshd" "error"
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
        msg "failed to enable fail2ban" "warn"
    fi
}

configure_ufw() {
    msg "configuring firewall rules via ufw"

    if ! sudo ufw default deny incoming; then
        msg "failed to set ufw default incoming policy" "error"
        return 1
    fi

    sudo ufw default allow outgoing
    sudo ufw logging medium
    sudo ufw delete allow ssh &>/dev/null || true
    sudo ufw delete allow "${SSH_PORT}/tcp" &>/dev/null || true

    if [[ -n "${SSH_ALLOWED_SUBNET}" ]]; then
        sudo ufw allow from "${SSH_ALLOWED_SUBNET}" to any port "${SSH_PORT}" proto tcp

        # Allow all TCP/UDP from subnet unless restricted
        if [[ -z "${RESTRICT_SUBNET_PORTS}" ]]; then
            sudo ufw allow from "${SSH_ALLOWED_SUBNET}"
        fi
    else
        sudo ufw limit "${SSH_PORT}/tcp"
    fi

    # Try to enable ufw - may fail if kernel modules aren't loaded yet
    if ! sudo ufw --force enable 2>/dev/null; then
        msg "ufw enable skipped (kernel modules not available)" "notice"
        msg "ufw will activate on next boot via systemd" "notice"
    fi

    if ! sudo systemctl enable ufw.service; then
        msg "failed to enable ufw service" "warn"
    fi
}

enable_services() {
    msg "enabling monitoring services"
    local services=(
        smartd.service
        sysstat.service
        cronie.service
    )

    for service in "${services[@]}"; do
        if ! sudo systemctl enable --now "${service}"; then
            msg "failed to enable ${service}" "warn"
        fi
    done
}

configure_lid_switch() {
    msg "configuring lid switch to ignore (laptop-as-server)"
    local conf_dir="/etc/systemd/logind.conf.d"
    local conf_file="${conf_dir}/99-laptop-server.conf"

    sudo mkdir -p "${conf_dir}"
    sudo tee "${conf_file}" >/dev/null <<'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

    sudo systemctl restart systemd-logind.service
}

configure_motd() {
    msg "installing MOTD generator script"
    sudo tee /usr/local/bin/generate-motd >/dev/null <<'MOTD_EOF'
#!/bin/bash
# Server MOTD generator - run by systemd timer

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

{
# ASCII Art - Paranoid server penguin
cat << 'EOF'

    .--.      "Who goes there?!"
   |o_o |
   |:_/ |     I'm watching the logs...
  //   \ \    and I have FIREWALL!
 (|     | )
/\'_   _/`\
\___)=(___/

EOF

echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Welcome to $(hostname)${NC}"
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

if command -v pacman &>/dev/null; then
    echo -e "${YELLOW}▸ Updates:${NC}   $(pacman -Qu 2>/dev/null | wc -l) packages"
fi

FAILED=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
if [[ "${FAILED}" -gt 0 ]]; then
    echo -e "${RED}▸ ALERT:${NC}     ${FAILED} failed service(s)!"
fi

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
} > /etc/motd
MOTD_EOF
    sudo chmod +x /usr/local/bin/generate-motd

    msg "installing MOTD systemd service"
    sudo tee /etc/systemd/system/motd-update.service >/dev/null <<'SERVICE_EOF'
[Unit]
Description=Update MOTD

[Service]
Type=oneshot
ExecStart=/usr/local/bin/generate-motd
SERVICE_EOF

    msg "installing MOTD systemd timer"
    sudo tee /etc/systemd/system/motd-update.timer >/dev/null <<'TIMER_EOF'
[Unit]
Description=Update MOTD every 5 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
TIMER_EOF

    sudo systemctl daemon-reload
    sudo systemctl enable --now motd-update.timer
    sudo /usr/local/bin/generate-motd
}

remind_sensors() {
    if command -v sensors-detect &>/dev/null; then
        msg "run 'sudo sensors-detect' manually to configure lm_sensors" "notice"
    fi
}

show_security_audit() {
    if command -v arch-audit &>/dev/null; then
        msg "security audit:" "info"
        arch-audit || true
    fi
}
