{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.python.enable {
    home.packages = with pkgs; [
      uv
      pre-commit
    ];

    home.sessionVariables = {
      UV_PYTHON_PREFERENCE = "only-managed";
    };
  };
}