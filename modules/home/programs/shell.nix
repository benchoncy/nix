{ lib, ... }: {
  home.file = {
    ".zshrc".source = ./config/.zshrc;
    ".bashrc".source = ./config/.bashrc;
    ".config/shell".source = ./config/shell;
    ".config/starship.toml".source = ./config/starship.toml;
  };
}
