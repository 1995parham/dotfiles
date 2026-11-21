#!/usr/bin/env bash

# Helpers for Claude Code's on-disk layout.
#
# Claude Code keeps per-project state under ~/.claude/projects/<encoded-cwd>,
# where <encoded-cwd> is the absolute project path with every '/', '.' and '_'
# replaced by '-'. Two consumers need that encoding to agree byte-for-byte
# (the dotfiles claude module that links memory dirs, and any helper that
# registers a new project), so it lives here in exactly one place.

# claude_project_dir_name <absolute-path>
#
# Prints the ~/.claude/projects entry name for the given project path.
#
#   $HOME/Documents/Git/foo     -> -Users-parham-Documents-Git-foo (macOS)
#   $HOME/Documents/Git/foo     -> -home-parham-Documents-Git-foo  (Linux)
#   $HOME/Git/a_b/c.d           -> -Users-parham-Git-a-b-c-d
claude_project_dir_name() {
    local path="${1:?claude_project_dir_name: path required}"
    path="${path%/}"

    # Claude Code maps every character outside [A-Za-z0-9] to '-' (spaces too).
    local name="${path//[^A-Za-z0-9]/-}"

    printf '%s' "${name}"
}

# claude_project_dir <absolute-path>
#
# Prints the full ~/.claude/projects/<encoded> directory for the project.
claude_project_dir() {
    local path="${1:?claude_project_dir: path required}"
    printf '%s/.claude/projects/%s' "${HOME}" "$(claude_project_dir_name "${path}")"
}
