#!/usr/bin/env bash

# Generic service management library
# Provides cross-platform service management for systemd (Linux) and launchctl (macOS)

# Detect the service manager type based on the operating system
# Returns: "launchctl" for macOS, "systemctl" for Linux with systemd, or "unknown"
function detect_service_manager() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "launchctl"
    elif [[ "$(command -v systemctl)" ]]; then
        echo "systemctl"
    else
        echo "unknown"
    fi
}

# Start a service
# Arguments:
#   $1: service_name - The name of the service to start
#   $2: service_manager - Optional. If not provided, will auto-detect
# Returns: 0 on success, 1 on failure
function service_start() {
    local service_name=$1
    local service_manager=${2:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        sudo launchctl kickstart -k "system/${service_name}"
        ;;
    systemctl)
        systemctl start "${service_name}"
        ;;
    *)
        return 1
        ;;
    esac
}

# Stop a service
# Arguments:
#   $1: service_name - The name of the service to stop
#   $2: service_manager - Optional. If not provided, will auto-detect
# Returns: 0 on success, 1 on failure
function service_stop() {
    local service_name=$1
    local service_manager=${2:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        sudo launchctl kill SIGTERM "system/${service_name}"
        ;;
    systemctl)
        systemctl stop "${service_name}"
        ;;
    *)
        return 1
        ;;
    esac
}

# Restart a service
# Arguments:
#   $1: service_name - The name of the service to restart
#   $2: service_manager - Optional. If not provided, will auto-detect
# Returns: 0 on success, 1 on failure
function service_restart() {
    local service_name=$1
    local service_manager=${2:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        sudo launchctl kill SIGTERM "system/${service_name}"
        sleep 1
        sudo launchctl kickstart -k "system/${service_name}"
        ;;
    systemctl)
        systemctl restart "${service_name}"
        ;;
    *)
        return 1
        ;;
    esac
}

# Get a human-readable name for the service manager
# Arguments:
#   $1: service_manager - Optional. If not provided, will auto-detect
# Returns: Human-readable name of the service manager
function service_manager_name() {
    local service_manager=${1:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        echo "darwin, using launchctl"
        ;;
    systemctl)
        echo "linux, using systemd"
        ;;
    *)
        echo "unknown service manager"
        ;;
    esac
}
