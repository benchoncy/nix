{ config, lib, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.github.enable {
    imports = [
      ../../../programs/gh.nix
      ../../../programs/gh-dash.nix
    ];

    home.file = {
      ".local/scripts/gh-dash-pr-review" = {
        source = ./scripts/gh-dash-pr-review.sh;
        executable = true;
      };
    };
  };
}