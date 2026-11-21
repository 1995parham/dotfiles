#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

test_claude_project_dir_name_plain() {
    assert_equals "$(claude_project_dir_name "/home/parham/Documents/Git/foo")" "-home-parham-Documents-Git-foo"
}

test_claude_project_dir_name_macos() {
    assert_equals "$(claude_project_dir_name "/Users/parham/Documents/Git/foo")" "-Users-parham-Documents-Git-foo"
}

test_claude_project_dir_name_special_chars() {
    assert_equals "$(claude_project_dir_name "/home/parham/Git/a_b/c.d")" "-home-parham-Git-a-b-c-d"
}

test_claude_project_dir_name_space() {
    assert_equals "$(claude_project_dir_name "/Users/parham/Library/Application Support/rs.x")" "-Users-parham-Library-Application-Support-rs-x"
}

test_claude_project_dir_name_trailing_slash() {
    assert_equals "$(claude_project_dir_name "/home/parham/Git/foo/")" "-home-parham-Git-foo"
}

test_claude_project_dir() {
    assert_equals "$(HOME=/home/parham claude_project_dir "/home/parham/Git/foo")" "/home/parham/.claude/projects/-home-parham-Git-foo"
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
