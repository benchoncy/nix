#!/usr/bin/env bash
# ~/.bashrc

# Load the shared shell configuration
source $HOME/.config/shell/init.sh

# Load fzf integration
eval "$(fzf --bash)"

# Start starship prompt
eval "$(starship init bash)"

# Initialize zoxide
eval "$(zoxide init bash --cmd cd)"
