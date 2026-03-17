{ ... }: {
  imports = [
    ../options.nix
    ../assets.nix
    ../capabilities/core.nix
    ../capabilities/programs-base.nix
    ../capabilities/git.nix
    ../capabilities/ghostty.nix
    ../capabilities/shell-extras.nix
    ../capabilities/tmux.nix
    ../capabilities/raw-files-compat.nix
    ../capabilities/work-overlay.nix
  ];
}
