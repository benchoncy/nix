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
    ./github
    ./aws
    ./podman.nix
    ./k8s
  ];
}
