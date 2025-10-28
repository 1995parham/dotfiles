#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

test_require_host_success() {
    assert_retval require_host "127.0.0.1" 0
}

test_require_host_failed() {
    assert_retval require_host "github.home" 1
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
