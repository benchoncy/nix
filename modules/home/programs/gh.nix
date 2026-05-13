{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.github.ghDash.enable {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [ gh-dash ];
    };
  };
}
