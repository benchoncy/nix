{ ... }: {
  imports = [
    ./core.nix
    ./secrets.nix
    ./raw-files-compat.nix
    ../../programs/ghostty.nix
    ../../programs/shell.nix
    ../../programs/scripts.nix
    ../../programs/git.nix
    ../../programs/tmux.nix
    ../../programs/shell-extras.nix
    ../../programs/neovim.nix
    ../../programs/firefox.nix
    ../../programs/obsidian
  ];
}