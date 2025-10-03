#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

sample_loader="${root}/loader.conf"

test_systemd_kernel_parameter_parsing() {
    assert_retval _add_systemd_kernel_parameter "${sample_loader}" "psr" 0
    assert_retval [ "$(grep options "${sample_loader}")" = "options cryptdevice=PARTUUID=1d5763a3-7f25-4edf-8360-9e2ddd1b9440:luksdev root=/dev/mapper/luksdev zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs quiet splash psr" ] 0
    assert_retval _remove_systemd_kernel_parameter "${sample_loader}" "psr" 0
    assert_retval [ "$(grep options "${sample_loader}")" = "options cryptdevice=PARTUUID=1d5763a3-7f25-4edf-8360-9e2ddd1b9440:luksdev root=/dev/mapper/luksdev zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs quiet splash" ] 0
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
