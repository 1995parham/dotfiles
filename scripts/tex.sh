#!/usr/bin/env bash

usage() {
    echo -n "TeX Live is the reference distribution of the TeX typesetting system, here with XeLaTeX, latexmk and the packages Persian documents need."
    # shellcheck disable=1004,2028
    echo '
 _____   __  __  _     _
|_   _|__\ \/ / | |   (_)_   _____
  | |/ _ \\  /  | |   | \ \ / / _ \
  | |  __//  \  | |___| |\ V /  __/
  |_|\___/_/\_\ |_____|_| \_/ \___|

	'
}

main_pacman() {
    # texlive-langarabic carries xepersian, texlive-latexextra carries minted,
    # and texlive-binextra carries latexmk and latexindent. Swap the collections
    # for texlive-meta to pull in every collection instead.
    require_pacman \
        texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra \
        texlive-fontsrecommended texlive-langarabic texlive-xetex texlive-binextra \
        texlab python-pygments graphviz perl
    require_aur libxcrypt-compat

    # install the required perl modules (to use latexindent)
    sudo cpan -i App::cpanminus
    sudo cpanm YAML::Tiny
    sudo cpanm File::HomeDir
    sudo cpanm Unicode::GCString
    sudo cpanm Log::Log4perl
    sudo cpanm Log::Dispatch::File
}

main_brew() {
    # MacTeX without its GUI applications is the full TeX Live distribution, and
    # brings xelatex, latexmk, latexindent and tlmgr with it.
    require_brew_cask mactex-no-gui

    # pygments is needed by minted, which shells out to pygmentize
    require_brew texlab pygments
}
