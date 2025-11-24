# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, ... }:
with pkgs; [
  coreutils
  gcc
  neovim
  tree-sitter
  git
  wget
  curl
  gnugrep
  ripgrep
  jq
  yq
  fd
  unzip
  chezmoi
  fzf
  bash
  zsh
  zsh-autosuggestions
  podman
  granted
  cargo
  lua
  luarocks
  go
  nodejs_24
  python313
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
