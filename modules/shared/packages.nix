# NixOS module that defines shared system packages
# Search https://search.nixos.org/packages for available packages
{ pkgs, username, ... }: {
  environment.systemPackages = with pkgs; [
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
  ];

  # Enable Firefox
  programs.firefox.enable = true;
  
  # Enable 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
	  enable = true;
	  polkitPolicyOwners = [ "${username}" ];
  };
}
