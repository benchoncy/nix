{ lib, pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Hack Nerd Font Mono";
      cursor-style = "block";
      cursor-style-blink = true;
      cursor-invert-fg-bg = true;
      shell-integration-features = "no-cursor";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      font-size = 17.0;
    };
  };

  catppuccin.ghostty.enable = true;
}
