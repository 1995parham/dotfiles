#!/usr/bin/env bash

# aggregate all scripts and load them in one place.

dotfile_lib_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=message.sh
source "$dotfile_lib_root/message.sh"
# shellcheck source=proxy.sh
source "$dotfile_lib_root/proxy.sh"
# shellcheck source=linker.sh
source "$dotfile_lib_root/linker.sh"
# shellcheck source=require.sh
source "$dotfile_lib_root/require.sh"