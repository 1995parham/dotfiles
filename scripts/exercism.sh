#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : exercism.sh
#
# [] Creation Date : 30-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
usage() {
        echo "usage: exercism"
}

main() {
        message "exercism" "Getting version information"
        exercism_v=$(curl -s https://api.github.com/repos/exercism/cli/releases/latest | grep 'tag_name' | cut -d\" -f4)

        message "exercism" "Downloading exercism $exercism_v"
        curl -L -# "https://github.com/exercism/cli/releases/download/${exercism_v}/exercism-linux-64bit.tgz" -o exercism.tgz
        tar -vxzf exercism.tgz
}
