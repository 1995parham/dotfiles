#!/bin/bash

# shellcheck disable=2046
layout=$(
	fd .\.yaml "$HOME/.config/tmuxp" |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--preview="cat {}"
)

tmuxp load "$layout"
