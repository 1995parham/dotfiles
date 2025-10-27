#!/usr/bin/env bash

root="${root:?"root must be set"}"
yes_to_all=${yes_to_all:-false}

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

#######################################
# Ensures a directory exists with proper error handling.
# Globals:
#   None
# Arguments:
#   $1 - directory path to create
#   $2 - module name for logging
# Returns:
#   0 on success, 1 on failure
#######################################
_ensure_directory() {
    local dir_path="${1:?'directory path required'}"
    local module="${2:?'module name required'}"

    if [[ ! -d "${dir_path}" ]]; then
        if ! mkdir -p "${dir_path}" 2>/dev/null; then
            message "${module}" "Failed to create directory: ${dir_path}" "error"
            return 1
        fi
        message "${module}" "Created directory: ${dir_path}" "debug"
    fi

    return 0
}

#######################################
# Validates a path before destructive operations.
# Arguments:
#   $1 - path to validate
#   $2 - operation type (for error messages)
# Returns:
#   0 if safe, 1 if dangerous
#######################################
_validate_path_safety() {
    local path="${1:?'path required'}"
    local operation="${2:-'operation'}"

    # Check if path is empty
    if [[ -z "${path}" ]]; then
        message "safety" "Refusing ${operation}: empty path" "error"
        return 1
    fi

    # Check for dangerous paths
    case "${path}" in
    "/" | "/bin" | "/sbin" | "/usr" | "/usr/bin" | "/usr/sbin" | "/etc" | "/lib" | "/lib64")
        message "safety" "Refusing ${operation}: critical system path ${path}" "error"
        return 1
        ;;
    "${HOME}" | "${HOME}/")
        message "safety" "Refusing ${operation}: home directory ${path}" "error"
        return 1
        ;;
    esac

    return 0
}

#######################################
# Performs diff with proper error handling and portability.
# Arguments:
#   $1 - first file path
#   $2 - second file path
#   $3 - use sudo (true/false)
# Returns:
#   0 if files are identical, 1 if different
#######################################
_safe_diff() {
    local file1="${1:?'file1 required'}"
    local file2="${2:?'file2 required'}"
    local use_sudo="${3:-false}"

    local diff_cmd="diff"
    local diff_args=(-y)

    # Add side-by-side comparison
    if diff --help 2>&1 | grep -q -- '--suppress-common-lines'; then
        # GNU diff
        diff_args+=(-N --suppress-common-lines)
    else
        # BSD diff fallback
        diff_args+=()
    fi

    if [[ "${use_sudo}" == "true" ]]; then
        diff_cmd="sudo diff"
    fi

    ${diff_cmd} "${diff_args[@]}" "${file1}" "${file2}" 2>/dev/null || return 1
    return 0
}

#######################################
# Gets the canonical path a symlink points to, with portability.
# Arguments:
#   $1 - symlink path
# Returns:
#   Prints the target path, returns 0 on success, 1 on failure
#######################################
_get_symlink_target() {
    local link_path="${1:?'link path required'}"

    # Not a symlink
    if [[ ! -L "${link_path}" ]]; then
        return 1
    fi

    # Try readlink -f (GNU) first, fall back to readlink (BSD)
    if readlink -f "${link_path}" 2>/dev/null; then
        return 0
    elif readlink "${link_path}" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

#######################################
# Copy a file from root into the given destination.
# Shows the difference before copying. Useful for setup files in /etc, /usr, etc.
# Globals:
#   root - The root directory path
#   yes_to_all - Skip confirmation prompts if true
# Arguments:
#   $1 - module name (for logging)
#   $2 - source file path (relative to $root)
#   $3 - destination file path (absolute)
#   $4 - use sudo for operations (true/false, default: true)
# Returns:
#   0 on success, 1 on failure or user cancellation
#######################################
copycat() {
    local module="${1:?'module name required'}"
    local src="${2:?'copycat requires source'}"
    local dest="${3:?'copycat requires destination'}"
    local use_sudo="${4:-true}"
    local needs_confirmation=false

    local src_path="${root}/${src}"

    # Validate source exists
    if [[ ! -f "${src_path}" ]]; then
        message "${module}" "Source file does not exist: ${src_path}" "error"
        return 1
    fi

    # Validate destination path
    if ! _validate_path_safety "${dest}" "copy to"; then
        return 1
    fi

    # Show diff if destination exists
    message "${module}" "Comparing ${src_path} and ${dest}:"
    echo

    if [[ -f "${dest}" ]]; then
        if ! _safe_diff "${src_path}" "${dest}" "${use_sudo}"; then
            needs_confirmation=true
        fi
    else
        message "${module}" "Destination does not exist (new file will be created)" "notice"
        needs_confirmation=true
    fi

    echo

    # Ask for confirmation if needed
    if [[ "${needs_confirmation}" == "true" ]]; then
        if ! yes_or_no "${module}" "Do you want to replace ${dest}?"; then
            return 1
        fi
    fi

    # Perform copy with error handling
    if [[ "${use_sudo}" == "true" ]]; then
        if ! sudo cp -f "${src_path}" "${dest}"; then
            message "${module}" "Failed to copy ${src_path} to ${dest}" "error"
            return 1
        fi
    else
        if ! cp -f "${src_path}" "${dest}"; then
            message "${module}" "Failed to copy ${src_path} to ${dest}" "error"
            return 1
        fi
    fi

    message "${module}" "Successfully copied ${src_path} to ${dest}" "success"
    return 0
}

#######################################
# Creates a config file in the home directory with a soft link to it.
# Can handle two cases:
#   1. Link $root/$module/$file to ~/.$file
#   2. Link $root/$module to ~/.$module
# Globals:
#   root - The root directory path
# Arguments:
#   $1 - module name
#   $2 - file name (optional, defaults to module name)
#   $3 - add dot prefix to make hidden (true/false, default: true)
# Returns:
#   0 on success, 1 on failure
#######################################
dotfile() {
    local module="${1:?'module name required'}"
    local file="${2:-}"
    local is_hidden="${3:-true}"

    local dst_file
    if [[ "${is_hidden}" == "true" ]]; then
        dst_file=".${file:-${module}}"
    else
        dst_file="${file:-${module}}"
    fi

    local src_file="${file}"
    local dst_path="${HOME}/${dst_file}"
    local src_path="${root}/${module}/${src_file}"

    linker "${module}" "${src_path}" "${dst_path}"
}

#######################################
# Creates a config file in .config directory with a soft link to it.
# For better organization, modules can be gathered into a directory.
# Globals:
#   root - The root directory path
#   XDG_CONFIG_HOME - Config directory (defaults to ~/.config)
# Arguments:
#   $1 - module name
#   $2 - file name (optional)
#   $3 - source directory prefix (optional)
# Returns:
#   0 on success, 1 on failure
#######################################
configfile() {
    local module="${1:?'module name required'}"
    local src_file="${2:-}"
    local src_dir="${3:-}"

    # Ensure .config exists
    _ensure_directory "${XDG_CONFIG_HOME}" "${module}" || return 1

    local src_path
    local dst_file
    local dst_path

    if [[ -n "${src_file}" ]]; then
        # Linking a specific file within the module
        src_path="${root}${src_dir:+/${src_dir}}/${module}/${src_file}"
        dst_file="${module}/${src_file}"

        # Ensure module subdirectory exists
        _ensure_directory "${XDG_CONFIG_HOME}/${module}" "${module}" || return 1
    else
        # Linking the entire module directory
        src_file="${module}"
        src_path="${root}${src_dir:+/${src_dir}}/${module}"
        dst_file="${module}"
    fi

    dst_path="${XDG_CONFIG_HOME}/${dst_file}"

    linker "${module}" "${src_path}" "${dst_path}"
}

#######################################
# Creates a config file in .config directory (root level) with a soft link.
# Globals:
#   root - The root directory path
#   XDG_CONFIG_HOME - Config directory (defaults to ~/.config)
# Arguments:
#   $1 - module name
#   $2 - file name
#   $3 - source directory prefix (optional)
# Returns:
#   0 on success, 1 on failure
#######################################
configrootfile() {
    local module="${1:?'module name required'}"
    local src_file="${2:?'configrootfile requires src_file'}"
    local src_dir="${3:-}"

    # Ensure .config exists
    _ensure_directory "${XDG_CONFIG_HOME}" "${module}" || return 1

    local src_path="${root}${src_dir:+/${src_dir}}/${module}/${src_file}"
    local dst_file="${src_file}"
    local dst_path="${XDG_CONFIG_HOME}/${dst_file}"

    linker "${module}" "${src_path}" "${dst_path}"
}

#######################################
# Creates a systemd user service file in .config/systemd/user with a soft link.
# Globals:
#   root - The root directory path
#   XDG_CONFIG_HOME - Config directory (defaults to ~/.config)
# Arguments:
#   $1 - module name
#   $2 - file name
#   $3 - source directory prefix (optional)
# Returns:
#   0 on success, 1 on failure
#######################################
configsystemd() {
    local module="${1:?'module name required'}"
    local src_file="${2:?'configsystemd requires src_file'}"
    local src_dir="${3:-}"

    local systemd_dir="${XDG_CONFIG_HOME}/systemd/user"

    # Ensure systemd user directory exists
    _ensure_directory "${systemd_dir}" "${module}" || return 1

    local src_path="${root}${src_dir:+/${src_dir}}/${module}/${src_file}"
    local dst_file="${src_file}"
    local dst_path="${systemd_dir}/${dst_file}"

    linker "${module}" "${src_path}" "${dst_path}"
}

#######################################
# Core linking function that creates symbolic links.
# Handles existing files/links with user confirmation.
# Globals:
#   yes_to_all - Skip confirmation prompts if true
# Arguments:
#   $1 - module name (for logging)
#   $2 - source path (absolute)
#   $3 - destination path (absolute)
# Returns:
#   0 on success, 1 on failure or user cancellation
#######################################
linker() {
    local module="${1:?'module name required'}"
    local src_path="${2:?'linker requires src_path'}"
    local dst_path="${3:?'linker requires dst_path'}"

    local create_link=true

    # Validate source exists
    if [[ ! -e "${src_path}" ]] && [[ ! -L "${src_path}" ]]; then
        message "${module}" "Source does not exist: ${src_path}" "error"
        return 1
    fi

    # Validate destination path safety
    if ! _validate_path_safety "${dst_path}" "link to"; then
        return 1
    fi

    # Check if destination already exists
    if [[ -e "${dst_path}" ]] || [[ -L "${dst_path}" ]]; then
        message "${module}" "${dst_path} already exists"

        # Check if it's already pointing to the correct location
        if [[ -L "${dst_path}" ]]; then
            local current_target
            current_target=$(_get_symlink_target "${dst_path}") || current_target=""

            if [[ "${src_path}" == "${current_target}" ]]; then
                message "${module}" "${dst_path} already points to correct location" "success"
                return 0
            fi

            message "${module}" "Current target: ${current_target}" "notice"
            message "${module}" "Desired target: ${src_path}" "notice"
        fi

        # Ask user if they want to remove existing file/link
        if yes_or_no "${module}" "Do you want to remove ${dst_path}?"; then
            # Additional safety check before removal
            if ! _validate_path_safety "${dst_path}" "remove"; then
                return 1
            fi

            # Use appropriate removal method
            if [[ -L "${dst_path}" ]] || [[ -f "${dst_path}" ]]; then
                # It's a symlink or regular file
                if ! rm -f "${dst_path}"; then
                    message "${module}" "Failed to remove ${dst_path}" "error"
                    return 1
                fi
            elif [[ -d "${dst_path}" ]]; then
                # It's a directory
                if ! rm -rf "${dst_path}"; then
                    message "${module}" "Failed to remove directory ${dst_path}" "error"
                    return 1
                fi
            fi

            action "${module}" "${dst_path} removed successfully"
        else
            create_link=false
        fi
    fi

    # Create the symbolic link
    if [[ "${create_link}" == "true" ]]; then
        if ! ln -s "${src_path}" "${dst_path}"; then
            message "${module}" "Failed to create symlink from ${src_path} to ${dst_path}" "error"
            return 1
        fi
        action "${module}" "Symbolic link created: ${dst_path} -> ${src_path}"
    fi

    return 0
}
