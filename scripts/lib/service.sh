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

# Every function below takes --user as its first argument to work on a service of the user
# and not of the system: a systemd user unit (systemctl --user, no sudo), or a launchd agent
# in the gui/<uid> domain.

# Run systemctl on a system unit or a user unit.
# It does not call sudo for a system unit: start, stop and restart leave the question of
# root to systemd (polkit asks), as they always did. service_enable adds sudo by itself.
# Arguments:
#   $1: scope - "system" or "user"
#   $2...: the systemctl arguments
function _service_systemctl() {
    local scope=$1
    shift

    if [[ "${scope}" == "user" ]]; then
        systemctl --user "$@"
    else
        systemctl "$@"
    fi
}

# Run launchctl on a system daemon or an agent of the user.
# Arguments:
#   $1: scope - "system" or "user"
#   $2: service_name
#   $3...: the launchctl subcommand and its flags; the service target is added last
function _service_launchctl() {
    local scope=$1
    local service_name=$2
    shift 2

    if [[ "${scope}" == "user" ]]; then
        launchctl "$@" "gui/${UID}/${service_name}"
    else
        sudo launchctl "$@" "system/${service_name}"
    fi
}

# Start a service
# Arguments:
#   --user: Optional. A service of the user, not of the system
#   $1: service_name - The name of the service to start
#   $2: service_manager - Optional. If not provided, will auto-detect
# Returns: 0 on success, 1 on failure
function service_start() {
    local scope="system"
    if [[ "${1:-}" == "--user" ]]; then
        scope="user"
        shift
    fi

    local service_name=$1
    local service_manager=${2:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        _service_launchctl "${scope}" "${service_name}" kickstart -k
        ;;
    systemctl)
        _service_systemctl "${scope}" start "${service_name}"
        ;;
    *)
        return 1
        ;;
    esac
}

# Stop a service
# Arguments:
#   --user: Optional. A service of the user, not of the system
#   $1: service_name - The name of the service to stop
#   $2: service_manager - Optional. If not provided, will auto-detect
# Returns: 0 on success, 1 on failure
function service_stop() {
    local scope="system"
    if [[ "${1:-}" == "--user" ]]; then
        scope="user"
        shift
    fi

    local service_name=$1
    local service_manager=${2:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        _service_launchctl "${scope}" "${service_name}" kill SIGTERM
        ;;
    systemctl)
        _service_systemctl "${scope}" stop "${service_name}"
        ;;
    *)
        return 1
        ;;
    esac
}

# Restart a service
# Arguments:
#   --user: Optional. A service of the user, not of the system
#   $1: service_name - The name of the service to restart
#   $2: service_manager - Optional. If not provided, will auto-detect
# Returns: 0 on success, 1 on failure
function service_restart() {
    local scope="system"
    if [[ "${1:-}" == "--user" ]]; then
        scope="user"
        shift
    fi

    local service_name=$1
    local service_manager=${2:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        _service_launchctl "${scope}" "${service_name}" kill SIGTERM
        sleep 1
        _service_launchctl "${scope}" "${service_name}" kickstart -k
        ;;
    systemctl)
        _service_systemctl "${scope}" restart "${service_name}"
        ;;
    *)
        return 1
        ;;
    esac
}

# Enable a service so that it starts at boot (or at login, for a service of the user), and
# start it now
# Arguments:
#   --user: Optional. A service of the user, not of the system
#   --no-start: Optional. Enable only. For a unit that can start only inside a session that
#               does not run yet (a unit bound to the compositor, enabled from a console)
#   $1: service_name - The name of the service to enable
#   $2: service_manager - Optional. If not provided, will auto-detect
# Returns: 0 on success, 1 on failure
# Example: service_enable docker.service
# Example: service_enable --user mpd.service
# Example: service_enable --user --no-start swayidle.service
function service_enable() {
    local scope="system"
    local start=true

    while [[ "${1:-}" == --* ]]; do
        case "$1" in
        --user) scope="user" ;;
        --no-start) start=false ;;
        *)
            message "service" "service_enable does not know $1" "error"
            return 1
            ;;
        esac
        shift
    done

    local service_name=$1
    local service_manager=${2:-$(detect_service_manager)}

    case "$service_manager" in
    launchctl)
        _service_launchctl "${scope}" "${service_name}" enable || return 1
        if [[ "${start}" == true ]]; then
            _service_launchctl "${scope}" "${service_name}" kickstart
        fi
        ;;
    systemctl)
        local -a enable=(enable)
        if [[ "${start}" == true ]]; then
            enable+=(--now)
        fi

        # a system unit needs root; a user unit must not get it, because root has other units.
        if [[ "${scope}" == "user" ]]; then
            systemctl --user "${enable[@]}" "${service_name}"
        else
            sudo systemctl "${enable[@]}" "${service_name}"
        fi
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
