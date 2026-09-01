{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    coreutils
    gcc
    gnumake
    neovim
    uv
    git
    wget
    curl
    gnugrep
    ripgrep
    jq
    yq
    fd
    unzip
    gum
    bash
    google-chrome
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
