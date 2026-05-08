{ config, lib, pkgs, osConfig, ... }: {
  home.packages = with pkgs; [
    coreutils
    gcc
    gnumake
    neovim
    git
    wget
    curl
    gnugrep
    ripgrep
    jq
    yq
    fd
    unzip
    fzf
    gum
    delta
    diffnav
    bash
    zsh
    granted
    starship
    tmux
    zoxide
    zotero
    nerd-fonts.hack
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    # For Linux only
    obsidian
    ghostty
    displaylink
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    # For Darwin only
    ghostty-bin
  ];
}
