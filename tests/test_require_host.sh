#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

test_require_host_success() {
    assert_retval require_host "127.0.0.1" 0
}

# An empty label makes the name invalid, so ping fails before any DNS query.
# A name that only does not exist is not enough: a FakeIP resolver answers
# every name, and a TUN gateway answers ICMP for every address.
test_require_host_failed() {
    assert_retval require_host "github..invalid" 1
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
