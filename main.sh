#!/usr/bin/env bash

# aggregate all scripts and load them in one place.

source="$0"
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    source="${BASH_SOURCE[0]}"
fi

dotfile_lib_root="$(cd "$(dirname "${source}")" && pwd)"

# shellcheck source=message.sh
source "${dotfile_lib_root}/message.sh"
# shellcheck source=proxy.sh
source "${dotfile_lib_root}/proxy.sh"
# shellcheck source=semver.sh
source "${dotfile_lib_root}/semver.sh"
if [[ -n "${root}" ]]; then
    # shellcheck source=linker.sh
    source "${dotfile_lib_root}/linker.sh"
fi
# shellcheck source=require.sh
source "${dotfile_lib_root}/require.sh"
# shellcheck source=clone.sh
source "${dotfile_lib_root}/clone.sh"
# shellcheck source=run.sh
source "${dotfile_lib_root}/run.sh"
# shellcheck source=service.sh
source "${dotfile_lib_root}/service.sh"
# shellcheck source=github.sh
source "${dotfile_lib_root}/github.sh"
