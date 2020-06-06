#!/bin/bash

current_dir="$( cd "$( dirname "$(readlink -f ${BASH_SOURCE[0]})" )" && pwd )"
source $current_dir/../../scripts/lib/proxy.sh

usage() {
        echo "proxy [start/stop]"
}

if [ $# -ne 1 ]; then
        usage
        exit 1
fi

if [ $1 = "start" ]; then
        proxy_start
elif [ $1 = "stop" ]; then
        proxy_stop
else
        usage
fi
