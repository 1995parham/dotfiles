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
    if [ -n "$1" ]; then
        name="$1"
    else
        read -r -p "name: " name
        if [[ "${name}" =~ [[:space:]]+ ]]; then
            msg "${name} cotains one or more spaces" "error"
            return 1
        fi
    fi

    local host
    host="$(hostname)"
    host="${host%.*}"
    if yes_or_no "do you want to be ${host} specific? "; then
        root="${root}/${host}"
    fi

    mkdir -p "${root}/scripts" || true

    if [[ -f "${root}/scripts/${name}.sh" ]]; then
        msg "${name} already exists" "error"
        return 1
    fi
    touch "${root}/scripts/${name}.sh"

    read -r -p 'dscription: ' description

    local root_env
    if yes_or_no 'do you need root? '; then
        # shellcheck disable=2016
        root_env='root=${root:?"root must be set"}'
    else
        root_env=''
    fi

    read -r -p 'user: ' -i "${USER}" -e user

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

    return 0
}
