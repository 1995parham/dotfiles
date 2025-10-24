#!/usr/bin/env bash

# Get the latest version tag from GitHub releases
_github_release_get_latest_version() {
    local repo=$1

    local version
    version=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" |
        grep '"tag_name":' | sed -E 's/.*"v?([^"]+)".*/\1/')

    if [[ -z "${version}" ]]; then
        message "github-release" "Failed to fetch latest version for ${repo}" "error"
        return 1
    fi

    echo "${version}"
    return 0
}

# Download a release file from GitHub
_github_release_download() {
    local download_url=$1
    local temp_file=$2

    if ! curl -fsSL -o "${temp_file}" "${download_url}"; then
        message "github-release" "Failed to download from ${download_url}" "error"
        return 1
    fi

    return 0
}

# Extract tar.gz or tgz archive
_github_release_extract_tar_gz() {
    local archive_file=$1
    local extract_dir=$2

    tar -xzf "${archive_file}" -C "${extract_dir}"
}

# Extract tar.xz archive
_github_release_extract_tar_xz() {
    local archive_file=$1
    local extract_dir=$2

    tar -xJf "${archive_file}" -C "${extract_dir}"
}

# Extract zip archive
_github_release_extract_zip() {
    local archive_file=$1
    local extract_dir=$2

    unzip -q "${archive_file}" -d "${extract_dir}"
}

# Handle DMG installation (macOS only)
_github_release_extract_dmg() {
    local dmg_file=$1
    local temp_dir=$2

    # Check if we're on a macOS system
    if [[ "$(uname -s)" != "Darwin" ]]; then
        message "github-release" ".dmg files are only supported on macOS systems" "error"
        return 1
    fi

    # Check if hdiutil is available
    if ! command -v hdiutil &>/dev/null; then
        message "github-release" "hdiutil not found - required for mounting DMG files" "error"
        return 1
    fi

    message "github-release" "Mounting DMG..." "info"

    local mount_point
    mount_point=$(hdiutil attach "${dmg_file}" -nobrowse -readonly | grep '/Volumes/' | awk '{print $3}')

    if [[ -z "${mount_point}" ]]; then
        message "github-release" "Failed to mount DMG" "error"
        return 1
    fi

    local app_bundle
    app_bundle=$(find "${mount_point}" -maxdepth 1 -name "*.app" -print -quit)

    if [[ -z "${app_bundle}" ]]; then
        message "github-release" "No .app bundle found in DMG" "error"
        hdiutil detach "${mount_point}" -quiet
        return 1
    fi

    message "github-release" "Installing app to /Applications..." "info"
    sudo cp -R "${app_bundle}" /Applications/

    hdiutil detach "${mount_point}" -quiet
    return 0
}

# Handle DEB installation (Debian/Ubuntu only)
_github_release_extract_deb() {
    local deb_file=$1
    local temp_dir=$2

    # Check if we're on a Linux system
    if [[ "$(uname -s)" != "Linux" ]]; then
        message "github-release" ".deb files are only supported on Linux systems" "error"
        return 1
    fi

    # Use apt if available (handles dependencies automatically)
    if command -v apt &>/dev/null; then
        message "github-release" "Installing DEB package with apt..." "info"

        if ! sudo apt install -y "${deb_file}"; then
            message "github-release" "Failed to install DEB package" "error"
            return 1
        fi
    # Fall back to dpkg + apt-get if apt is not available
    elif command -v apt-get &>/dev/null && command -v dpkg &>/dev/null; then
        message "github-release" "Installing DEB package with dpkg..." "info"

        if ! sudo dpkg -i "${deb_file}"; then
            message "github-release" "Fixing dependencies with apt-get..." "warn"

            if ! sudo apt-get install -f -y; then
                message "github-release" "Failed to fix dependencies" "error"
                return 1
            fi
        fi
    # Last resort: dpkg only (no dependency resolution)
    elif command -v dpkg &>/dev/null; then
        message "github-release" "Installing DEB package with dpkg (no dependency resolution available)..." "warn"

        if ! sudo dpkg -i "${deb_file}"; then
            message "github-release" "Failed to install DEB package" "error"
            message "github-release" "You may need to manually resolve dependencies" "notice"
            return 1
        fi
    else
        message "github-release" "No package manager found - .deb files are only supported on Debian-based systems" "error"
        return 1
    fi

    return 0
}

# Extract archive based on extension
_github_release_extract() {
    local archive_file=$1
    local archive_ext=$2
    local extract_dir=$3
    local binary_name=$4

    case "${archive_ext}" in
    tar.gz | tgz)
        _github_release_extract_tar_gz "${archive_file}" "${extract_dir}"
        ;;
    tar.xz)
        _github_release_extract_tar_xz "${archive_file}" "${extract_dir}"
        ;;
    zip)
        _github_release_extract_zip "${archive_file}" "${extract_dir}"
        ;;
    dmg)
        _github_release_extract_dmg "${archive_file}" "${extract_dir}"
        return $?
        ;;
    deb)
        _github_release_extract_deb "${archive_file}" "${extract_dir}"
        return $?
        ;;
    "")
        # No extraction needed, just rename the file
        mv "${archive_file}" "${extract_dir}/${binary_name}"
        ;;
    *)
        message "github-release" "Unsupported archive type: ${archive_ext}" "error"
        return 1
        ;;
    esac

    return 0
}

# Install binary to the installation directory
_github_release_install_binary() {
    local temp_dir=$1
    local binary_name=$2
    local install_dir=$3

    if [[ ! -f "${temp_dir}/${binary_name}" ]]; then
        message "github-release" "Binary ${binary_name} not found in archive" "error"
        return 1
    fi

    chmod +x "${temp_dir}/${binary_name}"
    mv "${temp_dir}/${binary_name}" "${install_dir}/"

    return 0
}

# Build download URL for the release
_github_release_build_url() {
    local repo=$1
    local version=$2
    local release_name
    release_name=$(eval echo "$3")
    local archive_ext=$4

    if [ -n "$archive_ext" ]; then
        echo "https://github.com/${repo}/releases/download/v${version}/${release_name}.${archive_ext}"
    else
        echo "https://github.com/${repo}/releases/download/v${version}/${release_name}"
    fi
}

# Install binary from GitHub releases
function require_github_release() {
    local repo=${1:?"GitHub repo (owner/name) is required"}
    local binary_name
    binary_name=$(eval echo "${2:?'binary name is required'}")
    local release_name=${3:?'release name is required (e.g., clash-aarch64-apple-darwin)'}
    local archive_ext=${4:-""}

    local install_dir="${HOME}/.local/bin"
    mkdir -p "${install_dir}"

    if [[ -f "${install_dir}/${binary_name}" ]]; then
        running "require" " github-release ${repo} (already installed)"
        return 0
    fi

    action "require" " github-release ${repo}"

    local version
    if ! version=$(_github_release_get_latest_version "${repo}"); then
        return 1
    fi

    message "github-release" "Installing version ${version}" "info"

    local download_url
    download_url=$(_github_release_build_url "${repo}" "${version}" "${release_name}" "${archive_ext}")

    local temp_dir
    temp_dir=$(mktemp -d)
    local temp_file="${temp_dir}/archive.${archive_ext}"

    if ! _github_release_download "${download_url}" "${temp_file}"; then
        rm -rf "${temp_dir}"
        return 1
    fi

    if ! _github_release_extract "${temp_file}" "${archive_ext}" "${temp_dir}" "${binary_name}"; then
        rm -rf "${temp_dir}"
        return 1
    fi

    if [[ "${archive_ext}" != "dmg" && "${archive_ext}" != "deb" ]]; then
        if ! _github_release_install_binary "${temp_dir}" "${binary_name}" "${install_dir}"; then
            rm -rf "${temp_dir}"
            return 1
        fi
    fi

    rm -rf "${temp_dir}"

    message "github-release" "Successfully installed ${binary_name} to ${install_dir}" "success"

    if ! echo "${PATH}" | grep -q "${install_dir}"; then
        message "github-release" "${install_dir} is not in your PATH" "warn"
        message "github-release" "Add 'export PATH=\"\$PATH:${install_dir}\"' to your shell config" "notice"
    fi

    return 0
}
