{ ... }: {
  imports = [
    ./core.nix
    ./git.nix
    ./ghostty.nix
    ./opencode.nix
    ./programs-base.nix
    ./raw-files-compat.nix
    ./shell-extras.nix
    ./tmux.nix
  ];
}
