#!/bin/bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=require.sh
source "$root/../require.sh"

test_require_host_success() {
	assert_retval require_host "github.com" 0
}

test_require_host_failed() {
	assert_retval require_host "github.home" 1
}

# shellcheck source=unit.sh
source "$root/../unit.sh"
