{ lib, pkgs, ... }: {
  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Macchiato
    font-family = Hack Nerd Font Mono
  '' + lib.optionalString pkgs.stdenv.isDarwin ''
    font-size = 17.0
  '';
}
