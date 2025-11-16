{ pkgs, ... }:
with pkgs; [
  coreutils
  neovim
  git
  wget
  curl
  gnugrep
  jq
  yq
  chezmoi
  fzf
  bash
  zsh
  podman
  granted
  lua
  go
  pre-commit
  uv
  starship
  tmux
  zoxide
]
