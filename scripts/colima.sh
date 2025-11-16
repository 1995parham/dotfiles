#!/usr/bin/env bash

usage() {
    echo "Colima - Container runtimes on macOS with minimal setup"

    # shellcheck disable=1004,2016
    echo '
           _ _
  ___ ___ | |_|_____ ___
 |  _| . | | |     | .  |
 |___|___|_|_|_|_|_|__,|
  '
}

root=${root:?"root must be set"}

pre_main() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        msg 'Colima is primarily designed for macOS' 'error'
        msg 'For Linux, consider using Docker Desktop or native Docker' 'notice'
        return 1
    fi

    msg 'Colima provides container runtimes (Docker, Containerd, Incus) on macOS'
    msg 'This script will install Colima and optionally configure it'
    echo
    msg 'Default configuration:'
    msg '  - CPU: 4 cores'
    msg '  - Memory: 8 GB'
    msg '  - Disk: 100 GB'
    msg '  - Runtime: Docker'
    msg '  - Kubernetes: Disabled (can be enabled later)'
}

main_brew() {
    msg "Install Colima"
    require_brew colima

    msg "Install Docker CLI (required for docker runtime)"
    require_brew docker docker-compose docker-credential-helper
}

main_pacman() {
    msg 'Colima is designed for macOS' 'error'
    msg 'On Linux, use native Docker or Podman instead' 'notice'
    return 1
}

main_apt() {
    msg 'Colima is designed for macOS' 'error'
    msg 'On Linux, use native Docker or Podman instead' 'notice'
    return 1
}

setup_colima_config() {
    local config_dir="$HOME/.colima/_templates"
    local config_file="$config_dir/default.yaml"

    if ! mkdir -p "$config_dir"; then
        msg 'Failed to create Colima config directory' 'error'
        return 1
    fi

    copycat "colima" "colima/colima.yaml" "$config_file" 0
}

setup_rosetta() {
    if [[ "$(uname -m)" == "arm64" ]]; then
        local macos_version
        macos_version=$(sw_vers -productVersion | cut -d. -f1)

        if [[ "$macos_version" -ge 13 ]]; then
            msg 'Your Mac supports Rosetta 2 for better x86_64 compatibility' 'notice'

            if yes_or_no 'colima' 'Enable Rosetta 2 emulation (requires macOS 13+)?'; then
                local config_file="$HOME/.colima/_templates/default.yaml"
                if [[ -f "$config_file" ]]; then
                    # Uncomment Rosetta settings
                    sed -i.bak 's/^# vmType: vz$/vmType: vz/' "$config_file"
                    sed -i.bak 's/^# rosetta: true$/rosetta: true/' "$config_file"
                    rm -f "$config_file.bak"
                    ok 'colima' 'Rosetta 2 enabled in configuration'
                fi
            fi
        fi
    fi
}

main() {
    if yes_or_no 'colima' 'Install Colima configuration?'; then
        setup_colima_config
        setup_rosetta
    fi

    echo
    msg '========================================'
    msg 'Colima Setup Complete!' 'success'
    msg '========================================'
    echo
    msg 'Quick Start Commands:' 'notice'
    echo
    msg '  colima start              Start Colima with default settings'
    msg '  colima start --edit       Edit configuration before starting'
    msg '  colima start --kubernetes Enable Kubernetes'
    msg '  colima stop               Stop Colima'
    msg '  colima delete             Delete Colima VM'
    msg '  colima status             Check Colima status'
    msg '  colima ssh                SSH into the VM'
    echo
    msg 'Runtime-specific commands:' 'notice'
    echo
    msg '  docker ps                 List containers (Docker runtime)'
    msg '  colima nerdctl            Use nerdctl (Containerd runtime)'
    echo
    msg 'Configuration file location:'
    msg '  ~/.colima/_templates/default.yaml'
    echo
    msg 'Documentation: https://github.com/abiosoft/colima'
    msg '========================================'

    echo
    if yes_or_no 'colima' 'Start Colima now?'; then
        running 'colima' 'Starting Colima...'

        if colima start; then
            ok 'colima' 'Colima started successfully'

            # Show status
            msg 'Current Colima status:'
            colima status

            # Test Docker
            if command -v docker &>/dev/null; then
                msg 'Testing Docker connectivity...'
                if docker ps &>/dev/null; then
                    ok 'colima' 'Docker is working correctly'
                else
                    msg 'Docker connectivity issue' 'warn'
                    msg 'Try running: docker context use colima' 'notice'
                fi
            fi
        else
            msg 'Failed to start Colima' 'error'
            msg 'Check the logs with: colima logs' 'notice'
            return 1
        fi
    else
        msg 'You can start Colima later with: colima start' 'notice'
    fi
}

main_parham() {
    msg 'Setting up Docker context for Colima' 'notice'

    if command -v docker &>/dev/null && colima status &>/dev/null; then
        if docker context use colima &>/dev/null; then
            ok 'colima' 'Docker context set to colima'
        fi
    fi
}
