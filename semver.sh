#!/usr/bin/env bash

function semver_compare() {
    # version1 > version2 -> gt
    # version1 == version2 -> eq
    # version1 < version2 -> lt

    version1=${1:?"version-1 required"}
    version2=${2:?"version-2 required"}

    # first, replace the dots by blank spaces:

    version1=${version1//./ }
    version2=${version2//./ }

    # can get rid of staring 'v':

    version1=${version1//v/}
    version2=${version2//v/}

    patch1="$(echo "$version1" | awk '{print $3}')"
    minor1="$(echo "$version1" | awk '{print $2}')"
    major1="$(echo "$version1" | awk '{print $1}')"

    patch2="$(echo "$version2" | awk '{print $3}')"
    minor2="$(echo "$version2" | awk '{print $2}')"
    major2="$(echo "$version2" | awk '{print $1}')"

    if [ "$major1" -gt "$major2" ]; then
        echo -n "gt"
        return
    elif [ "$major1" -lt "$major2" ]; then
        echo -n "lt"
        return
    fi

    if [ "$minor1" -gt "$minor2" ]; then
        echo -n "gt"
        return
    elif [ "$minor1" -lt "$minor2" ]; then
        echo -n "lt"
        return
    fi

    if [ "$patch1" -gt "$patch2" ]; then
        echo -n "gt"
        return
    elif [ "$patch1" -lt "$patch2" ]; then
        echo -n "lt"
        return
    fi

    echo -n "eq"
}
