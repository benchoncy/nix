{ config, lib, pkgs, ... }: {
  options = {
    github.tooling.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GitHub CLI tooling packages.";
    };
  };

  config = lib.mkIf config.github.tooling.enable {
    home.packages = with pkgs; [
      github-cli
      gh-dash
      diffnav
    ];
  };
}
