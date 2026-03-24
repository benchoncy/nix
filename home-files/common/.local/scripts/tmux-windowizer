#!/usr/bin/env bash
# Adapted from ThePrimeagen (https://github.com/ThePrimeagen/.dotfiles)
# Manages tmux windows for project/worktree contexts

help() {
    exit_code=${1:-0}
    echo "usage: $0 [-h] [-s session] [-p project-or-worktree] [-n task-name] [--pull] [-w window-name]"
    echo "  -h, --help: show help"
    echo "  -s, --session: tmux session name"
    echo "  -p, --project: explicit project/worktree path"
    echo "  -n, --name: create/reuse this task worktree name"
    echo "      --pull: fetch origin before worktree creation"
    echo "  -w, --window-name: tmux window name override"
    exit "$exit_code"
}

session_name=""
project=""
worktree_name=""
window_name=""
pull_flag=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            help
            ;;
        -s|--session)
            session_name="$2"
            shift 2
            ;;
        -p|--project)
            project="$2"
            shift 2
            ;;
        -n|--name)
            worktree_name="$2"
            shift 2
            ;;
        --pull)
            pull_flag="--pull"
            shift
            ;;
        -w|--window-name)
            window_name="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1" >&2
            help 1
            ;;
    esac
done

# if no session name, use current session
if [[ -z $session_name ]]; then
    if [[ -z $TMUX ]]; then
        echo "No tmux session provided and not currently in tmux." >&2
        exit 1
    fi
    session_name=$(tmux display-message -p '#S' 2> /dev/null)
fi

# if no project/worktree directory, select one
if [[ -z $project ]]; then
    project=$(find "$HOME/Projects" -mindepth 3 -maxdepth 4 -type d 2> /dev/null \
        | fzf --prompt="Repo/Worktree > ")
fi

if [[ -z $project ]]; then
    exit 0
fi

target_path="$project"
project_name=$(basename "$project")

# if selecting a project root (*.tree), create/reuse a task worktree
if [[ $project_name == *.tree ]]; then
    cmd=(git-afforester worktree create --project "$project" --default-worktree "$session_name")

    if [[ -n $worktree_name ]]; then
        cmd+=("$worktree_name")
    fi
    if [[ -n $pull_flag ]]; then
        cmd+=("$pull_flag")
    fi

    if ! target_path=$("${cmd[@]}"); then
        echo "Failed to create/reuse worktree for project: $project" >&2
        exit 1
    fi
fi

target_name=$(basename "$target_path")
if [[ -n $window_name ]]; then
    target_name="$window_name"
fi

echo "Creating new tmux window: $target_name in session: $session_name"
tmux new-window -t "$session_name" -c "$target_path" -n "$target_name"
