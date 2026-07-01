#!/usr/bin/env bash

usage() {
    echo -n -e "pixi for machine learning and data science"

    # shellcheck disable=1004,2016
    echo '
       _      _
 _ __ (_)_  _(_)
| _ \| \ \/ / |
| |_) | |>  <| |
| .__/|_/_/\_\_|
|_|

  '
}

main_pacman() {
    require_pacman ttf-liberation
    require_pacman pixi
}

main_brew() {
    require_brew pixi
}

main() {
    if ! command -v pixi &>/dev/null; then
        msg 'pixi is not on PATH; open a new shell or add ~/.pixi/bin' 'error'
        return 1
    fi

    # A single global environment that exposes jupyter and keeps the usual
    # data-science libraries importable inside it. Re-running is idempotent:
    # pixi only installs what is missing.
    msg 'installing the global data-science environment (jupyterlab + libs)'
    if ! pixi global install --environment datascience \
        jupyterlab pandas numpy geopandas polars xlrd; then
        msg 'failed to install the pixi datascience environment' 'error'
        return 1
    fi

    msg 'pixi global binaries live in ~/.pixi/bin (added to PATH in zshenv)' 'notice'
}
