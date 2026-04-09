{ ... }: {
  imports = [
    ./ai-policy.nix
    ./core.nix
    ./git.nix
    ./github-tooling.nix
    ./ghostty.nix
    ./opencode.nix
    ./programs-base.nix
    ./raw-files-compat.nix
    ./secrets.nix
    ./shell-extras.nix
    ./tmux.nix
  ];
}
