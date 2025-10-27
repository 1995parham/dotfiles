#!/usr/bin/env bash

assert_equals() {
    if [[ "$#" -ne 2 ]]; then
        message "assert" "assert_equal requires 2 arguments" "error"
        return 1
    fi

    value="$1"
    expect="$2"

    if [[ "${value}" != "${expect}" ]]; then
        message "assert" "expects ${expect} but found ${value}" "error"
        return 1
    fi

    return 0
}

assert_retval() {
    expect="${*: -1}"
    args=("$@")
    unset "args[${#args[@]}-1]"
    "${args[@]}"
    value="$?"

    if [[ "${value}" -ne "${expect}" ]]; then
        message "assert" "expects ${expect} during the execution of \"${args[*]}\" but found ${value}" "error"
        return 1
    fi

    return 0
}

set -eu
set -o pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=message.sh
source "${root}/message.sh"

declare -F | while read -r unit_test; do
    unit_test="${unit_test#"declare -f "}"

    if [[ "${unit_test}" =~ ^test_* ]]; then
        "${unit_test}" || (
            message "${unit_test}" 'failed' 'error'
            return 1
        )

        message "${unit_test}" 'passed'
    fi
done
