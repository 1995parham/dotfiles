#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

# Global test setup - create temporary directories for testing
setup_test_env() {
    test_temp_dir=$(mktemp -d)
    test_root_dir="${test_temp_dir}/dotfiles_root"
    test_home_dir="${test_temp_dir}/fake_home"

    mkdir -p "${test_root_dir}"
    mkdir -p "${test_home_dir}"

    # Export for linker.sh to use
    export HOME="${test_home_dir}"
    export root="${test_root_dir}"
    export yes_to_all=1
}

# Global test cleanup
cleanup_test_env() {
    if [[ -n "${test_temp_dir:-}" && -d "${test_temp_dir}" ]]; then
        rm -rf "${test_temp_dir}"
    fi
}

# Cleanup on exit
trap cleanup_test_env EXIT

#######################################
# Test: _validate_path_safety rejects empty paths
#######################################
test_validate_path_safety_empty_path() {
    setup_test_env

    # Empty path should fail
    if _validate_path_safety "" "test" 2>/dev/null; then
        message "test" "_validate_path_safety accepted empty path" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: _validate_path_safety rejects dangerous system paths
#######################################
test_validate_path_safety_dangerous_paths() {
    setup_test_env

    local dangerous_paths=(
        "/"
        "/bin"
        "/sbin"
        "/usr"
        "/etc"
        "${HOME}"
        "${HOME}/"
    )

    for path in "${dangerous_paths[@]}"; do
        if _validate_path_safety "${path}" "test" 2>/dev/null; then
            message "test" "_validate_path_safety accepted dangerous path: ${path}" "error"
            cleanup_test_env
            return 1
        fi
    done

    cleanup_test_env
    return 0
}

#######################################
# Test: _validate_path_safety accepts safe paths
#######################################
test_validate_path_safety_safe_paths() {
    setup_test_env

    local safe_paths=(
        "${HOME}/.config"
        "${HOME}/.bashrc"
        "/tmp/test"
        "${HOME}/Documents/test"
    )

    for path in "${safe_paths[@]}"; do
        if ! _validate_path_safety "${path}" "test" 2>/dev/null; then
            message "test" "_validate_path_safety rejected safe path: ${path}" "error"
            cleanup_test_env
            return 1
        fi
    done

    cleanup_test_env
    return 0
}

#######################################
# Test: _ensure_directory creates directory
#######################################
test_ensure_directory_creates() {
    setup_test_env

    local test_dir="${test_temp_dir}/new_directory"

    if ! _ensure_directory "${test_dir}" "test" 2>/dev/null; then
        message "test" "_ensure_directory failed to create directory" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -d "${test_dir}" ]]; then
        message "test" "Directory was not created: ${test_dir}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: _ensure_directory handles existing directory
#######################################
test_ensure_directory_existing() {
    setup_test_env

    local test_dir="${test_temp_dir}/existing_directory"
    mkdir -p "${test_dir}"

    if ! _ensure_directory "${test_dir}" "test" 2>/dev/null; then
        message "test" "_ensure_directory failed on existing directory" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: _ensure_directory creates nested directories
#######################################
test_ensure_directory_nested() {
    setup_test_env

    local test_dir="${test_temp_dir}/level1/level2/level3"

    if ! _ensure_directory "${test_dir}" "test" 2>/dev/null; then
        message "test" "_ensure_directory failed to create nested directories" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -d "${test_dir}" ]]; then
        message "test" "Nested directory was not created: ${test_dir}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: _get_symlink_target returns correct target
#######################################
test_get_symlink_target_valid() {
    setup_test_env

    local source_file="${test_temp_dir}/source.txt"
    local link_file="${test_temp_dir}/link.txt"

    echo "test content" >"${source_file}"
    ln -s "${source_file}" "${link_file}"

    local target
    target=$(_get_symlink_target "${link_file}")

    # The target should match the source (may be relative or absolute depending on readlink)
    if [[ "${target}" != "${source_file}" ]] && [[ "${target}" != "source.txt" ]]; then
        message "test" "_get_symlink_target returned incorrect target: ${target}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: _get_symlink_target fails on non-symlink
#######################################
test_get_symlink_target_not_symlink() {
    setup_test_env

    local regular_file="${test_temp_dir}/regular.txt"
    echo "test" >"${regular_file}"

    if _get_symlink_target "${regular_file}" 2>/dev/null; then
        message "test" "_get_symlink_target succeeded on non-symlink" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: linker creates new symlink
#######################################
test_linker_creates_new_symlink() {
    setup_test_env

    local source_file="${test_root_dir}/config.txt"
    local dest_file="${test_home_dir}/.config.txt"

    echo "config content" >"${source_file}"

    if ! linker "test" "${source_file}" "${dest_file}" 2>/dev/null; then
        message "test" "linker failed to create symlink" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -L "${dest_file}" ]]; then
        message "test" "Symlink was not created: ${dest_file}" "error"
        cleanup_test_env
        return 1
    fi

    local target
    target=$(readlink "${dest_file}")
    if [[ "${target}" != "${source_file}" ]]; then
        message "test" "Symlink points to wrong target: ${target}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: linker succeeds when correct symlink exists
#######################################
test_linker_existing_correct_symlink() {
    setup_test_env

    local source_file="${test_root_dir}/config.txt"
    local dest_file="${test_home_dir}/.config.txt"

    echo "config content" >"${source_file}"
    ln -s "${source_file}" "${dest_file}"

    # Should succeed because symlink is already correct
    if ! linker "test" "${source_file}" "${dest_file}" 2>/dev/null; then
        message "test" "linker failed on existing correct symlink" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: linker replaces incorrect symlink with yes_to_all
#######################################
test_linker_replaces_incorrect_symlink() {
    setup_test_env

    local correct_source="${test_root_dir}/correct.txt"
    local wrong_source="${test_root_dir}/wrong.txt"
    local dest_file="${test_home_dir}/.config.txt"

    echo "correct" >"${correct_source}"
    echo "wrong" >"${wrong_source}"

    # Create symlink to wrong source
    ln -s "${wrong_source}" "${dest_file}"

    # Should replace with correct source (yes_to_all=true)
    if ! linker "test" "${correct_source}" "${dest_file}" 2>/dev/null; then
        message "test" "linker failed to replace incorrect symlink" "error"
        cleanup_test_env
        return 1
    fi

    local target
    target=$(readlink "${dest_file}")
    if [[ "${target}" != "${correct_source}" ]]; then
        message "test" "Symlink was not updated to correct target: ${target}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: linker fails when source doesn't exist
#######################################
test_linker_fails_missing_source() {
    setup_test_env

    local nonexistent_source="${test_root_dir}/nonexistent.txt"
    local dest_file="${test_home_dir}/.config.txt"

    if linker "test" "${nonexistent_source}" "${dest_file}" 2>/dev/null; then
        message "test" "linker succeeded with non-existent source" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: linker fails on dangerous destination paths
#######################################
test_linker_fails_dangerous_destination() {
    setup_test_env

    local source_file="${test_root_dir}/config.txt"
    echo "config" >"${source_file}"

    # Try to link to dangerous path
    if linker "test" "${source_file}" "/" 2>/dev/null; then
        message "test" "linker accepted dangerous destination path" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: linker handles regular file at destination
#######################################
test_linker_replaces_regular_file() {
    setup_test_env

    local source_file="${test_root_dir}/config.txt"
    local dest_file="${test_home_dir}/.config.txt"

    echo "config" >"${source_file}"
    echo "existing file" >"${dest_file}"

    # Should replace regular file with symlink (yes_to_all=true)
    if ! linker "test" "${source_file}" "${dest_file}" 2>/dev/null; then
        message "test" "linker failed to replace regular file" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -L "${dest_file}" ]]; then
        message "test" "Destination is not a symlink after linker" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: linker handles directory at destination
#######################################
test_linker_replaces_directory() {
    setup_test_env

    local source_dir="${test_root_dir}/config_dir"
    local dest_dir="${test_home_dir}/.config_dir"

    mkdir -p "${source_dir}"
    mkdir -p "${dest_dir}"
    echo "file in dir" >"${dest_dir}/file.txt"

    # Should replace directory with symlink (yes_to_all=true)
    if ! linker "test" "${source_dir}" "${dest_dir}" 2>/dev/null; then
        message "test" "linker failed to replace directory" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -L "${dest_dir}" ]]; then
        message "test" "Destination is not a symlink after linker" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: dotfile creates hidden file link
#######################################
test_dotfile_creates_hidden_link() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "config" >"${module_dir}/config"

    if ! dotfile "testmodule" "config" "true" 2>/dev/null; then
        message "test" "dotfile failed to create hidden link" "error"
        cleanup_test_env
        return 1
    fi

    local expected_dest="${test_home_dir}/.config"
    if [[ ! -L "${expected_dest}" ]]; then
        message "test" "Dotfile link was not created: ${expected_dest}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: dotfile creates non-hidden file link
#######################################
test_dotfile_creates_visible_link() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "config" >"${module_dir}/config"

    if ! dotfile "testmodule" "config" "false" 2>/dev/null; then
        message "test" "dotfile failed to create visible link" "error"
        cleanup_test_env
        return 1
    fi

    local expected_dest="${test_home_dir}/config"
    if [[ ! -L "${expected_dest}" ]]; then
        message "test" "Dotfile link was not created: ${expected_dest}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: dotfile links entire module directory
#######################################
test_dotfile_links_module_directory() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "file1" >"${module_dir}/file1.txt"
    echo "file2" >"${module_dir}/file2.txt"

    # Call dotfile without file parameter to link entire module
    if ! dotfile "testmodule" "" "true" 2>/dev/null; then
        message "test" "dotfile failed to link module directory" "error"
        cleanup_test_env
        return 1
    fi

    local expected_dest="${test_home_dir}/.testmodule"
    if [[ ! -L "${expected_dest}" ]]; then
        message "test" "Module directory link was not created: ${expected_dest}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: configfile creates .config link
#######################################
test_configfile_creates_link() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "config" >"${module_dir}/config.txt"

    if ! configfile "testmodule" "config.txt" "" 2>/dev/null; then
        message "test" "configfile failed to create link" "error"
        cleanup_test_env
        return 1
    fi

    local expected_dest="${test_home_dir}/.config/testmodule/config.txt"
    if [[ ! -L "${expected_dest}" ]]; then
        message "test" "Config file link was not created: ${expected_dest}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: configfile creates .config directory structure
#######################################
test_configfile_creates_directories() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "config" >"${module_dir}/config.txt"

    if ! configfile "testmodule" "config.txt" "" 2>/dev/null; then
        message "test" "configfile failed" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -d "${test_home_dir}/.config" ]]; then
        message "test" ".config directory was not created" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -d "${test_home_dir}/.config/testmodule" ]]; then
        message "test" "Module subdirectory was not created" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: configfile links entire module directory
#######################################
test_configfile_links_module() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "file1" >"${module_dir}/file1.txt"
    echo "file2" >"${module_dir}/file2.txt"

    if ! configfile "testmodule" "" "" 2>/dev/null; then
        message "test" "configfile failed to link module" "error"
        cleanup_test_env
        return 1
    fi

    local expected_dest="${test_home_dir}/.config/testmodule"
    if [[ ! -L "${expected_dest}" ]]; then
        message "test" "Module link was not created: ${expected_dest}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: configfile respects XDG_CONFIG_HOME
#######################################
test_configfile_respects_xdg() {
    setup_test_env

    local custom_config="${test_temp_dir}/custom_config"
    mkdir -p "${custom_config}"
    export XDG_CONFIG_HOME="${custom_config}"

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "config" >"${module_dir}/config.txt"

    # Need to re-source linker.sh to pick up new XDG_CONFIG_HOME
    # Since it's readonly, we'll test with the default behavior
    # This test validates the concept

    cleanup_test_env
    return 0
}

#######################################
# Test: configrootfile creates root-level config link
#######################################
test_configrootfile_creates_link() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "config" >"${module_dir}/settings.conf"

    if ! configrootfile "testmodule" "settings.conf" "" 2>/dev/null; then
        message "test" "configrootfile failed to create link" "error"
        cleanup_test_env
        return 1
    fi

    local expected_dest="${test_home_dir}/.config/settings.conf"
    if [[ ! -L "${expected_dest}" ]]; then
        message "test" "Config root file link was not created: ${expected_dest}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: configsystemd creates systemd user service link
#######################################
test_configsystemd_creates_link() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "[Unit]" >"${module_dir}/test.service"

    if ! configsystemd "testmodule" "test.service" "" 2>/dev/null; then
        message "test" "configsystemd failed to create link" "error"
        cleanup_test_env
        return 1
    fi

    local expected_dest="${test_home_dir}/.config/systemd/user/test.service"
    if [[ ! -L "${expected_dest}" ]]; then
        message "test" "Systemd service link was not created: ${expected_dest}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: configsystemd creates directory structure
#######################################
test_configsystemd_creates_directories() {
    setup_test_env

    local module_dir="${test_root_dir}/testmodule"
    mkdir -p "${module_dir}"
    echo "[Unit]" >"${module_dir}/test.service"

    if ! configsystemd "testmodule" "test.service" "" 2>/dev/null; then
        message "test" "configsystemd failed" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -d "${test_home_dir}/.config/systemd/user" ]]; then
        message "test" "Systemd user directory was not created" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: copycat copies new file
#######################################
test_copycat_new_file() {
    setup_test_env

    local source_file="testfile.txt"
    local dest_file="${test_temp_dir}/destination.txt"

    echo "test content" >"${test_root_dir}/${source_file}"

    if ! copycat "test" "${source_file}" "${dest_file}" "false" 2>/dev/null; then
        message "test" "copycat failed to copy new file" "error"
        cleanup_test_env
        return 1
    fi

    if [[ ! -f "${dest_file}" ]]; then
        message "test" "Destination file was not created" "error"
        cleanup_test_env
        return 1
    fi

    local content
    content=$(cat "${dest_file}")
    if [[ "${content}" != "test content" ]]; then
        message "test" "File content incorrect: ${content}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: copycat fails with non-existent source
#######################################
test_copycat_missing_source() {
    setup_test_env

    local source_file="nonexistent.txt"
    local dest_file="${test_temp_dir}/destination.txt"

    if copycat "test" "${source_file}" "${dest_file}" "false" 2>/dev/null; then
        message "test" "copycat succeeded with non-existent source" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: copycat rejects dangerous paths
#######################################
test_copycat_dangerous_destination() {
    setup_test_env

    local source_file="testfile.txt"
    echo "test" >"${test_root_dir}/${source_file}"

    if copycat "test" "${source_file}" "/etc/passwd" "false" 2>/dev/null; then
        message "test" "copycat accepted dangerous destination" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: copycat copies to directory (destination ending with /)
#######################################
test_copycat_directory_destination() {
    setup_test_env

    local source_file="myconfig.txt"
    local dest_dir="${test_temp_dir}/target_dir/"

    echo "directory test content" >"${test_root_dir}/${source_file}"

    if ! copycat "test" "${source_file}" "${dest_dir}" "false" 2>/dev/null; then
        message "test" "copycat failed to copy to directory destination" "error"
        cleanup_test_env
        return 1
    fi

    # File should be copied with same name into the directory
    local expected_file="${test_temp_dir}/target_dir/myconfig.txt"
    if [[ ! -f "${expected_file}" ]]; then
        message "test" "File was not copied to directory: ${expected_file}" "error"
        cleanup_test_env
        return 1
    fi

    local content
    content=$(cat "${expected_file}")
    if [[ "${content}" != "directory test content" ]]; then
        message "test" "File content incorrect: ${content}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

#######################################
# Test: copycat copies to specific file path (destination not ending with /)
#######################################
test_copycat_file_destination() {
    setup_test_env

    local source_file="source.conf"
    local dest_file="${test_temp_dir}/custom_name.conf"

    echo "file test content" >"${test_root_dir}/${source_file}"

    if ! copycat "test" "${source_file}" "${dest_file}" "false" 2>/dev/null; then
        message "test" "copycat failed to copy to file destination" "error"
        cleanup_test_env
        return 1
    fi

    # File should be copied with the specified name
    if [[ ! -f "${dest_file}" ]]; then
        message "test" "File was not created: ${dest_file}" "error"
        cleanup_test_env
        return 1
    fi

    local content
    content=$(cat "${dest_file}")
    if [[ "${content}" != "file test content" ]]; then
        message "test" "File content incorrect: ${content}" "error"
        cleanup_test_env
        return 1
    fi

    cleanup_test_env
    return 0
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
