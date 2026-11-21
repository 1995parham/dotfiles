#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

# every command that touches the system is replaced, so the tests run on any machine and as
# any user. each of them writes a line into ${calls}.
sandbox=$(mktemp -d)
calls="${sandbox}/calls"
export APT_KEYRINGS_DIR="${sandbox}/keyrings"
export APT_SOURCES_DIR="${sandbox}/sources.list.d"
mkdir -p "${APT_SOURCES_DIR}"
trap 'rm -rf "${sandbox}"' EXIT

# sudo is a function here too, so it does run the functions below.
# shellcheck disable=SC2032,SC2033
sudo() { "$@"; }
# shellcheck disable=SC2032
dpkg() { echo "amd64"; }
# shellcheck disable=SC2032
apt-get() { echo "apt-get $*" >>"${calls}"; }
curl() {
    echo "curl" >>"${calls}"
    # the output file is the last argument
    echo "a binary key" >"${*: -1}"
}

_reset() {
    rm -rf "${APT_KEYRINGS_DIR}" "${calls}"
    rm -f "${APT_SOURCES_DIR}"/*.list
    : >"${calls}"
}

test_require_apt_repo_writes_the_entry() {
    _reset
    require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "stable" &>/dev/null

    assert_equals "$(cat "${APT_SOURCES_DIR}/example.list")" \
        "deb [arch=amd64 signed-by=${APT_KEYRINGS_DIR}/example.gpg] https://example.com/apt stable main"
}

test_require_apt_repo_stores_the_key() {
    _reset
    require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "stable" &>/dev/null

    assert_equals "$(cat "${APT_KEYRINGS_DIR}/example.gpg")" "a binary key"
}

test_require_apt_repo_takes_components() {
    _reset
    require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "noble" "main" "contrib" &>/dev/null

    assert_equals "$(cat "${APT_SOURCES_DIR}/example.list")" \
        "deb [arch=amd64 signed-by=${APT_KEYRINGS_DIR}/example.gpg] https://example.com/apt noble main contrib"
}

test_require_apt_repo_updates_once() {
    _reset
    require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "stable" &>/dev/null
    require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "stable" &>/dev/null

    # the second call finds the key and the entry, so it downloads nothing and updates nothing.
    assert_equals "$(grep -c "" "${calls}")" "2"
}

test_require_apt_repo_rewrites_a_changed_entry() {
    _reset
    require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "stable" &>/dev/null
    require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "testing" &>/dev/null

    assert_equals "$(cat "${APT_SOURCES_DIR}/example.list")" \
        "deb [arch=amd64 signed-by=${APT_KEYRINGS_DIR}/example.gpg] https://example.com/apt testing main"
}

test_require_apt_repo_fails_without_the_key() {
    _reset
    curl() { return 22; }
    assert_retval require_apt_repo "example" "https://example.com/key" "https://example.com/apt" "stable" 1 &>/dev/null
    local result=$?
    curl() {
        echo "curl" >>"${calls}"
        echo "a binary key" >"${*: -1}"
    }

    return "${result}"
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
