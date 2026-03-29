# general env

# OS specific differences
if [[ $(uname) == "Darwin" ]]; then
  op_socket_path="~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  # homebrew
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
else
  op_socket_path="~/.1password/agent.sock"
fi

# 1password
if [[ -f $op_socket_path ]]; then
  export SSH_AUTH_SOCK=$op_socket_path
fi

if command -v op >/dev/null 2>&1; then
  if [[ -z "${OBSIDIAN_API_KEY:-}" ]]; then
    export OBSIDIAN_API_KEY="$(op read 'op://Private/Obsidian.md/api key' 2>/dev/null)"
  fi

  if [[ -z "${LANGUAGETOOL_USERNAME:-}" ]]; then
    export LANGUAGETOOL_USERNAME="$(op read 'op://Private/LanguageTool/username' 2>/dev/null)"
  fi

  if [[ -z "${LANGUAGETOOL_API_KEY:-}" ]]; then
    export LANGUAGETOOL_API_KEY="$(op read 'op://Private/LanguageTool/api key' 2>/dev/null)"
  fi
fi

# general
export EDITOR="nvim"
export LANG=en_GB.UTF-8

# custom scripts
export PATH="$PATH:$HOME/.local/scripts:$HOME/.local/bin"
