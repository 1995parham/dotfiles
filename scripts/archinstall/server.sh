#!/usr/bin/env bash

usage() {
    echo "provision a minimal arch linux server with security and stability packages"

    # shellcheck disable=1004,2016
    printf '
                                      ___
 ___  ___ _ ____   _____ _ __  __  __/ _ \
/ __|/ _ \ |__\ \ / / _ \ |__| \ \/ / | | |
\__ \  __/ |   \ V /  __/ |     >  <| |_| |
|___/\___|_|    \_/ \___|_|    /_/\_\\___/

    .--.      "Who goes there?!"
   |o_o |
   |:_/ |     I'\''m watching the logs...
  //   \ \    and I have FIREWALL!
 (|     | )
/'\''\_   _/`\
\___)=(___/
    '
}

export dependencies=("pacman" "yay" "env")

main_pacman() {
    # Security packages
    msg "installing security packages"
    require_pacman openssh ufw fail2ban arch-audit

    # Stability & monitoring packages
    msg "installing monitoring and stability packages"
    require_pacman smartmontools lm_sensors sysstat iotop logrotate cronie nvme-cli

    # Enable core services
    msg "enabling core services"
    if ! sudo systemctl enable --now sshd.service; then
        msg "failed to enable sshd" "error"
        return 1
    fi

    if ! sudo systemctl enable --now systemd-timesyncd.service; then
        msg "failed to enable timesyncd" "warn"
    fi

    if ! sudo systemctl enable --now cronie.service; then
        msg "failed to enable cronie" "warn"
    fi

    # Configure and enable firewall
    msg "configuring firewall (ufw)"
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw --force enable
    if ! sudo systemctl enable ufw.service; then
        msg "failed to enable ufw service" "warn"
    fi

    # Enable security services
    msg "enabling fail2ban"
    if ! sudo systemctl enable --now fail2ban.service; then
        msg "failed to enable fail2ban" "warn"
    fi

    # Enable monitoring services
    msg "enabling monitoring services"
    if ! sudo systemctl enable --now smartd.service; then
        msg "failed to enable smartd" "warn"
    fi

    if ! sudo systemctl enable --now sysstat.service; then
        msg "failed to enable sysstat" "warn"
    fi

    # Configure laptop lid to ignore (for laptop-as-server setups)
    msg "configuring lid switch to ignore (laptop-as-server)"
    sudo mkdir -p /etc/systemd/logind.conf.d
    echo '[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore' | sudo tee /etc/systemd/logind.conf.d/99-laptop-server.conf >/dev/null
    sudo systemctl restart systemd-logind
}

main() {
    # Install MOTD script
    msg "installing dynamic MOTD script"
    sudo tee /etc/profile.d/motd.sh >/dev/null <<'MOTD_EOF'
#!/bin/bash
# Server MOTD - displays system status on login

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ASCII Art - Paranoid server penguin
cat << 'EOF'

    .--.      "Who goes there?!"
   |o_o |
   |:_/ |     I'm watching the logs...
  //   \ \    and I have FIREWALL!
 (|     | )
/'\_   _/`\
\___)=(___/

EOF

echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Welcome to $(hostname)${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}▸ Uptime:${NC}    $(uptime -p)"
echo -e "${YELLOW}▸ Load:${NC}      $(cat /proc/loadavg | awk '{print $1, $2, $3}')"

MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_PCT=$((MEM_USED * 100 / MEM_TOTAL))
echo -e "${YELLOW}▸ Memory:${NC}    ${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PCT}%)"
echo -e "${YELLOW}▸ Disk /:${NC}    $(df -h / | awk 'NR==2 {print $5}') used"

[ -f /sys/class/thermal/thermal_zone0/temp ] && \
    echo -e "${YELLOW}▸ CPU Temp:${NC}  $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))°C"

command -v pacman &>/dev/null && \
    echo -e "${YELLOW}▸ Updates:${NC}   $(pacman -Qu 2>/dev/null | wc -l) packages"

FAILED=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
[ "$FAILED" -gt 0 ] && echo -e "${RED}▸ ALERT:${NC}     ${FAILED} failed service(s)!"

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
MOTD_EOF
    sudo chmod +x /etc/profile.d/motd.sh

    # Detect sensors (non-interactive)
    if command -v sensors-detect &>/dev/null; then
        msg "run 'sudo sensors-detect' manually to configure lm_sensors" "notice"
    fi

    # Show security audit
    if command -v arch-audit &>/dev/null; then
        msg "security audit:" "info"
        arch-audit || true
    fi

    msg "server provisioning complete" "success"
    msg "next steps:" "notice"
    msg "  - ./start.sh keys <github-username>  # add SSH keys"
    msg "  - ./start.sh docker                  # add Docker"
    msg "  - ./start.sh k3s                     # add Kubernetes"
}
