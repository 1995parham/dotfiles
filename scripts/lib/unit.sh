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

# Track test failures
test_failed=0
test_passed=0
test_total=0

# Use process substitution to avoid subshell issue
while read -r unit_test; do
    unit_test="${unit_test#"declare -f "}"

    if [[ "${unit_test}" =~ ^test_* ]]; then
        test_total=$((test_total + 1))

        if "${unit_test}"; then
            message "${unit_test}" 'passed'
            test_passed=$((test_passed + 1))
        else
            message "${unit_test}" 'failed' 'error'
            test_failed=$((test_failed + 1))
        fi
    fi
done < <(declare -F)

# Print summary
echo
if [[ ${test_failed} -gt 0 ]]; then
    message "test_summary" "${test_passed}/${test_total} tests passed, ${test_failed} failed" "error"
    exit 1
else
    message "test_summary" "All ${test_total} tests passed" "success"
    exit 0
fi
