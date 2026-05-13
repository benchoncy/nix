{ lib, ... }: {
  home.file = {
    ".zshrc".source = ./shell/config/.zshrc;
    ".bashrc".source = ./shell/config/.bashrc;
    ".config/shell".source = ./shell/config/shell;
    ".config/starship.toml".source = ./shell/config/starship.toml;
  };
}
