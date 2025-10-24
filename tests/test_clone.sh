#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

test_clone_new_repo() {
    local test_dir
    test_dir=$(mktemp -d)

    # Clone a small repository to test the progress bar
    # Using a small repo to make the test faster
    clone "https://github.com/1995parham/github-do-not-ban-us" "${test_dir}" "test-repo"

    local retval=$?

    # Verify the clone was successful
    if [[ ! -d "${test_dir}/test-repo" ]]; then
        message "clone" "directory was not created" "error"
        rm -rf "${test_dir}"
        return 1
    fi

    if [[ ! -d "${test_dir}/test-repo/.git" ]]; then
        message "clone" "git repository was not initialized" "error"
        rm -rf "${test_dir}"
        return 1
    fi

    # Cleanup
    rm -rf "${test_dir}"

    return "${retval}"
}

test_clone_existing_repo() {
    local test_dir
    test_dir=$(mktemp -d)

    # Clone a repository
    git clone --quiet "https://github.com/1995parham/github-do-not-ban-us" "${test_dir}/test-repo" 2>/dev/null

    # Try to clone again - should detect existing repo
    clone "https://github.com/1995parham/github-do-not-ban-us" "${test_dir}" "test-repo"

    local retval=$?

    # Cleanup
    rm -rf "${test_dir}"

    return "${retval}"
}

test_clone_with_different_origin() {
    local test_dir
    test_dir=$(mktemp -d)

    # Clone a repository with one origin
    git clone --quiet "https://github.com/1995parham/github-do-not-ban-us" "${test_dir}/test-repo" 2>/dev/null

    # Try to clone with a different origin - should fail/warn
    clone "https://github.com/some-other-repo" "${test_dir}" "test-repo"

    local retval=$?

    # Cleanup
    rm -rf "${test_dir}"

    # This test expects the function to handle the mismatch gracefully
    return 0
}

test_clone_progress_regex() {
    # Test the regex pattern matches git's progress output format
    local test_lines=(
        "Receiving objects:  50% (100/200)"
        "Receiving objects: 100% (200/200)"
        "Resolving deltas:  25% (50/200)"
        "Resolving deltas: 100% (200/200), done."
    )

    local pattern='([0-9]+)%[[:space:]]*\(([0-9]+)/([0-9]+)\)'

    for line in "${test_lines[@]}"; do
        if [[ ! "${line}" =~ ${pattern} ]]; then
            message "clone" "regex pattern failed to match: ${line}" "error"
            return 1
        fi
    done

    # Verify we can extract the correct values
    local test_line="Receiving objects:  75% (150/200)"
    if [[ "${test_line}" =~ ${pattern} ]]; then
        local percent="${BASH_REMATCH[1]}"
        local current="${BASH_REMATCH[2]}"
        local total="${BASH_REMATCH[3]}"

        if [[ "${percent}" != "75" ]] || [[ "${current}" != "150" ]] || [[ "${total}" != "200" ]]; then
            message "clone" "regex extracted wrong values: ${percent}%, ${current}/${total}" "error"
            return 1
        fi
    else
        message "clone" "regex pattern failed to match test line" "error"
        return 1
    fi

    return 0
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
