{ ... }: {
  imports = [
    ./packages.nix
    ./ghostty.nix
    ./shell.nix
    ./scripts.nix
    ./git.nix
    ./tmux.nix
    ./shell-extras.nix
    ./gh.nix
    ./gh-dash.nix
    ./opencode.nix
    ./neovim.nix
    ./firefox.nix
    ./obsidian
  ];
}
