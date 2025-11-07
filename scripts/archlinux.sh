#!/usr/bin/env bash

usage() {
    echo -n "Download the latest Arch Linux ISO"
    # shellcheck disable=2016
    echo '
                 _     _ _
  __ _ _ __ ___| |__ | (_)_ __  _   ___  __
 / _` | |__/ __| |_ \| | | |_ \| | | \ \/ /
| (_| | | | (__| | | | | | | | | |_| |>  <
 \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\

    '
}

main_brew() {
    return 0
}

main_apt() {
    return 0
}

main_pacman() {
    return 0
}

main() {
    local output_dir="${1:-$PWD}"
    local mirror="https://mirror.rackspace.com/archlinux"
    local iso_name="archlinux-x86_64.iso"
    local iso_url="${mirror}/iso/latest/${iso_name}"
    local output_file="${output_dir}/${iso_name}"

    message "archlinux" "Downloading latest Arch Linux ISO" "info"
    message "archlinux" "Mirror: ${mirror}" "info"
    message "archlinux" "Output: ${output_file}" "info"

    # Create output directory if it doesn't exist
    mkdir -p "${output_dir}"

    # Download the ISO
    if command -v wget &>/dev/null; then
        action "download" " using wget"
        if wget -O "${output_file}" "${iso_url}"; then
            message "archlinux" "Successfully downloaded ${iso_name}" "success"
        else
            message "archlinux" "Failed to download ISO" "error"
            return 1
        fi
    elif command -v curl &>/dev/null; then
        action "download" " using curl"
        if curl -L -o "${output_file}" "${iso_url}"; then
            message "archlinux" "Successfully downloaded ${iso_name}" "success"
        else
            message "archlinux" "Failed to download ISO" "error"
            return 1
        fi
    else
        message "archlinux" "Neither wget nor curl found" "error"
        return 1
    fi

    # Download checksums file
    local checksum_file="${output_dir}/sha256sums.txt"
    local checksum_url="${mirror}/iso/latest/sha256sums.txt"

    message "archlinux" "Downloading checksums" "info"
    if command -v wget &>/dev/null; then
        wget -q -O "${checksum_file}" "${checksum_url}"
    elif command -v curl &>/dev/null; then
        curl -sL -o "${checksum_file}" "${checksum_url}"
    fi

    # Verify checksum if possible
    if command -v sha256sum &>/dev/null && [[ -f "${checksum_file}" ]]; then
        message "archlinux" "Verifying checksum" "info"
        (cd "${output_dir}" && sha256sum -c --ignore-missing "${checksum_file}")
    elif command -v shasum &>/dev/null && [[ -f "${checksum_file}" ]]; then
        message "archlinux" "Verifying checksum" "info"
        local expected_sum
        expected_sum=$(grep "${iso_name}" "${checksum_file}" | awk '{print $1}')
        local actual_sum
        actual_sum=$(shasum -a 256 "${output_file}" | awk '{print $1}')
        if [[ "${expected_sum}" == "${actual_sum}" ]]; then
            message "archlinux" "Checksum verification passed" "success"
        else
            message "archlinux" "Checksum verification failed" "error"
            return 1
        fi
    fi

    message "archlinux" "ISO downloaded to: ${output_file}" "notice"
    return 0
}
