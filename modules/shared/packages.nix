# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, ... }:
with pkgs; [
  coreutils
  gcc
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
  zsh-autosuggestions
  podman
  granted
  lua
  go
  pre-commit
  uv
  starship
  tmux
  zoxide
  _1password-gui
  _1password-cli
  obsidian
  zotero
]
