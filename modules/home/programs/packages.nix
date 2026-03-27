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
    gum
    bash
    zsh
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
    zotero
    bruno
    bruno-cli
    nerd-fonts.hack
    # AI Agents and tools
    opencode
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
