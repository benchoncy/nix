args@{ config, lib, pkgs, ... }:
let
  osConfig = args.osConfig or {};
  profiles = osConfig.homeProfiles or config.homeProfiles;
in {
  config = lib.mkIf profiles.developer.python.enable {
    home.packages = with pkgs; [
      uv
      pre-commit
    ];

    home.sessionVariables = {
      UV_PYTHON_PREFERENCE = "only-managed";
    };
  };
}
