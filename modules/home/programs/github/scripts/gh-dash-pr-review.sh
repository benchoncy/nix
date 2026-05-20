#!/usr/bin/env bash

set -euo pipefail

help() {
    echo "usage: $0 <repo-name> <repo-path> <pr-number>"
    echo "  repo-name: full repository name, e.g. owner/repo"
    echo "  repo-path: local gh-dash repo path for the repo"
    echo "  pr-number: pull request number"
}

need_cmd() {
    if ! command -v "$1" > /dev/null 2>&1; then
        echo "Missing required command: $1" >&2
        exit 1
    fi
}

expand_home() {
    local path="$1"

    if [[ $path == ~/* ]]; then
        printf '%s\n' "$HOME/${path#~/}"
        return
    fi

    printf '%s\n' "$path"
}

window_exists() {
    local session_name="$1"
    local window_name="$2"

    tmux list-windows -t "$session_name" -F '#{window_name}' 2> /dev/null | grep -Fxq -- "$window_name"
}

attach_or_switch() {
    local session_name="$1"

    if [[ -z ${TMUX:-} ]]; then
        exec tmux attach-session -t "$session_name"
    fi

    tmux switch-client -t "$session_name"
}

main() {
    if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
        help
        exit 0
    fi

    if [[ $# -ne 3 ]]; then
        help >&2
        exit 1
    fi

    local repo_name="$1"
    local repo_path
    repo_path=$(expand_home "$2")
    local pr_number="$3"
    local repo_short_name="${repo_name##*/}"
    local session_name="${repo_short_name}-pr-${pr_number}"
    local worktree_path
    local diff_cmd

    need_cmd gh
    need_cmd tmux
    need_cmd git-afforester
    need_cmd diffnav
    need_cmd opencode

    worktree_path=$(git-afforester worktree create --project "$repo_path" "$session_name")

    (
        cd "$worktree_path"
        gh pr checkout --repo "$repo_name" "$pr_number" --detach
    )

    gh pr view --repo "$repo_name" "$pr_number" --web

    printf -v diff_cmd 'gh pr diff --repo %q %q | diffnav' "$repo_name" "$pr_number"

    if ! tmux has-session -t "$session_name" 2> /dev/null; then
        tmux new-session -d -s "$session_name" -c "$worktree_path" -n review 'opencode --prompt "/review with tests"'
        tmux new-window -t "$session_name" -c "$worktree_path" -n diff "$diff_cmd"
        tmux select-window -t "$session_name":review
        attach_or_switch "$session_name"
        return
    fi

    if ! window_exists "$session_name" review; then
        tmux new-window -t "$session_name" -c "$worktree_path" -n review 'opencode --prompt "/review with tests"'
    fi

    if ! window_exists "$session_name" diff; then
        tmux new-window -t "$session_name" -c "$worktree_path" -n diff "$diff_cmd"
    fi

    tmux select-window -t "$session_name":review
    attach_or_switch "$session_name"
}

main "$@"
