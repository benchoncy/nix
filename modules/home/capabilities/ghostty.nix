{ lib, pkgs, ... }: {
  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Macchiato
    font-family = Hack Nerd Font Mono
    cursor-style = block
    cursor-style-blink = true
    cursor-invert-fg-bg = true
  '' + lib.optionalString pkgs.stdenv.isDarwin ''
    font-size = 17.0
  '';
}
