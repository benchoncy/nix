#!/usr/bin/env bash
# Adapted from ThePrimeagen (https://github.com/ThePrimeagen/.dotfiles)
## Manages tmux sessions, optionally seeded from task naming

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
    session_options=""

    if command -v jira > /dev/null && command -v yq > /dev/null && command -v curl > /dev/null; then
        jira_server=$(yq ".server" ~/.config/.jira/.config.yml 2> /dev/null)
        if [[ -n $jira_server ]]; then
            jira_server_code=$(curl -f -s -m 1 "$jira_server" -o /dev/null -w "%{http_code}" 2> /dev/null)
            if [[ $jira_server_code -eq 200 || $jira_server_code -eq 302 ]]; then
                session_options+=$(jira issue list \
                    -q 'assignee = currentUser() AND resolution = Unresolved AND project IS NOT EMPTY' \
                    --plain \
                    --no-headers \
                    --columns key,summary 2> /dev/null)
                session_options+="\n"
            fi
        fi
    fi

    tmux_sessions=$(tmux list-sessions -F "#S|tmux session - #{session_windows} windows, created: #{t:session_created}#{?session_attached, (attached),}" 2> /dev/null)
    while IFS='|' read -r name description; do
        if [[ -n $name ]]; then
            session_options+=$(printf "%-16s%s" "$name" "$description")
            session_options+="\n"
        fi
    done <<< "$tmux_sessions"

    session_options=$(printf "%b" "$session_options" | sort -k 1 | uniq)
    selection=$(fzf --prompt="Session > " --print-query <<< "$session_options")
    session_name=$(printf "%s\n" "$selection" | awk 'END{print $1}')
fi

if [[ -z $session_name ]]; then
    exit 0
fi

# if session does not exist, create one and switch to it; if it doesn't exist
if ! tmux has-session -t "$session_name" 2> /dev/null; then
    echo "Creating new tmux session: $session_name"
    tmux new-session -ds "$session_name"
    if tmux-windowizer -s "$session_name"; then
        tmux kill-window -t "$session_name":1
    else
        echo "Warning: failed to create initial tmux window for $session_name" >&2
    fi
fi

echo "Switching to tmux session: $session_name"
if [[ -z $TMUX ]]; then
    tmux attach-session -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
