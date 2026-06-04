#!/usr/bin/env bash
# Adapted from ThePrimeagen (https://github.com/ThePrimeagen/.dotfiles)
## Manages tmux sessions

help() {
    echo "usage: $0 [-h] [--session name] [name]"
    echo "  -h, --help: show help"
    echo "  --session: explicit tmux session name"
    echo "  name: positional session name (same as --session)"
    exit 0
}

session_name=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            help
            ;;
        --session)
            session_name="$2"
            shift 2
            ;;
        *)
            if [[ $1 == -* ]]; then
                echo "Unknown argument: $1" >&2
                exit 1
            elif [[ -z $session_name ]]; then
                session_name="$1"
                shift
            else
                echo "Unexpected argument: $1" >&2
                exit 1
            fi
            ;;
    esac
done

if [[ -z $session_name ]]; then
    mode=$(printf "new\nsearch\n" | fzf --prompt="Session Mode > ")

    case "$mode" in
        new)
            read -r -p "New session name: " session_name
            ;;
        search)
            session_options=""

            tmux_sessions=$(tmux list-sessions -F "#S|tmux session - #{session_windows} windows, created: #{t:session_created}#{?session_attached, (attached),}" 2> /dev/null)
            while IFS='|' read -r name description; do
                if [[ -n $name ]]; then
                    session_options+=$(printf "%-16s%s" "$name" "$description")
                    session_options+="\n"
                fi
            done <<< "$tmux_sessions"

            session_options=$(printf "%b" "$session_options" | sort -k 1 | uniq)
            selection=$(fzf --prompt="Session > " <<< "$session_options")
            session_name=$(printf "%s\n" "$selection" | awk 'END{print $1}')
            ;;
        *)
            exit 0
            ;;
    esac
fi

if [[ -z $session_name ]]; then
    exit 0
fi

# if session does not exist, create one and switch to it
if ! tmux has-session -t "$session_name" 2> /dev/null; then
    echo "Creating new tmux session: $session_name"
    tmux new-session -ds "$session_name"
fi

echo "Switching to tmux session: $session_name"
if [[ -z $TMUX ]]; then
    tmux attach-session -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
