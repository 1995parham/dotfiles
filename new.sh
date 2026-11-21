#!/usr/bin/env bash

usage() {
    echo "create a new script just for you"

    # shellcheck disable=1004,2016
    echo '
 _ __   _____      __
| |_ \ / _ \ \ /\ / /
| | | |  __/\ V  V /
|_| |_|\___| \_/\_/
  '
}

root=${root:?"root must be set"}

main_pacman() {
    return 0
}

main_brew() {
    return 0
}

main_xbps() {
    return 0
}

main_pkg() {
    return 0
}

main_apt() {
    return 0
}

main() {
    if [ -n "${1+x}" ]; then
        name="$1"
    else
        read -r -p "name: " name
        if [[ "${name}" =~ [[:space:]]+ ]]; then
            msg "${name} contains one or more spaces" "error"
            return 1
        fi
    fi

    local host
    host="$(_host_short)"
    if yes_or_no "do you want to be ${host} specific? "; then
        root="${root}/hosts/${host}"
    fi

    mkdir -p "${root}/scripts" || true

    if [[ -f "${root}/scripts/${name}.sh" ]]; then
        msg "${name} already exists" "error"
        return 1
    fi
    touch "${root}/scripts/${name}.sh"

    read -r -p 'description: ' description

    local root_env
    if yes_or_no 'do you need root? '; then
        # shellcheck disable=2016
        root_env='root=${root:?"root must be set"}'
    else
        root_env=''
    fi

    read -r -p 'user: ' -i "${USER}" -e user

    # NOTE: bodies are indented with 4 spaces to match .editorconfig. The CI lint
    # (.github/workflows/sh-lint.yaml) runs shfmt, which reads .editorconfig and
    # rejects anything else — a 2-space template makes every generated script fail
    # CI on its first push.
    cat >>"${root}/scripts/${name}.sh" <<EOF
#!/usr/bin/env bash
usage() {
    echo "${description}"

    # shellcheck disable=1004,2016
    echo '
$(figlet "${name}" | tr "'" "|" | sed -e 's/[[:space:]]*$//')
    '
}

${root_env}

pre_main() {
    return 0
}

main_pacman() {
    return 1
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    return 1
}

main() {
    return 0
}

main_${user}() {
    return 0
}
EOF

    # An empty ${root_env} leaves a run of blank lines that shfmt collapses, which
    # would fail CI on a freshly-generated script. Normalise here when shfmt exists.
    if command -v shfmt >/dev/null 2>&1; then
        shfmt -w "${root}/scripts/${name}.sh"
    fi

    return 0
}
