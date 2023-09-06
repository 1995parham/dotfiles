#!/bin/bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$root/../require.sh"

test_with_semver() {
	assert_equals "$(semver_compare "1.0.0" "1.0.1")" "lt"
	assert_equals "$(semver_compare "1.0.0" "1.0.0")" "eq"
	assert_equals "$(semver_compare "1.0.0" "0.0.9")" "gt"
}

source "$root/../unit.sh"
