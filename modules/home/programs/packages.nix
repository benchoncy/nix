{ pkgs, ... }: {
  home.packages = with pkgs; [
    coreutils
    gcc
    gnumake
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
    fzf
    bash
    zsh
    zsh-autosuggestions
    podman
    cargo
    lua
    luarocks
    go
    nodejs_24
    python313
    granted
    chezmoi
    pre-commit
    uv
    starship
    tmux
    zoxide
    obsidian
    zotero
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    # For Linux only
    ghostty
    displaylink
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    # For macOS only
    ghostty-bin
  ];
}
