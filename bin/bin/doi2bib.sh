#!/bin/bash

basename=$0

help() {
	echo "$basename <doi>"
}

main() {
	if [ $# -ne 1 ]; then
		help
	fi

	doi=${1#"https://doi.org/"}

	echo "sending request for $doi"
	echo

	curl -# -L -H "Accept: application/x-bibtex; charset=utf-8" "https://doi.org/$doi"
}

main "$@"
