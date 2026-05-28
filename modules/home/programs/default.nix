{ ... }: {
  imports = [
    ./packages.nix
    ./ghostty.nix
    ./shell
    ./neovim
    ./firefox.nix
    ./obsidian
    ./tmux
    ./git
    ./opencode
    ./aws
    ./podman.nix
    ./k8s
  ];
}
