{ config, lib, pkgs, ... }: {
  options = {
    github.tooling.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GitHub CLI tooling packages.";
    };
  };

  config = lib.mkIf config.github.tooling.enable {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [ gh-dash ];
    };
  };
}
