{ pkgs, ... }: {
  home.packages = with pkgs; [
    tree-sitter
    ansible-language-server
    bash-language-server
    clang-tools
    docker-language-server
    gopls
    helm-ls
    vscode-langservers-extracted
    ltex-ls
    lua-language-server
    marksman
    ruff
    rust-analyzer
    taplo
    texlab
    tflint
    tofu-ls
    ty
    typescript-language-server
    yaml-language-server
    nixd
  ];
}
