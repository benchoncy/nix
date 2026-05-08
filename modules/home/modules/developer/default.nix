{ config, lib, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.enable {
    imports = [
      ./bruno.nix
      ./python.nix
      ./github.nix
      ./opencode.nix
      ./aws.nix
      ./go.nix
      ./rust.nix
      ./lua.nix
      ./containers.nix
      ./javascript.nix
      ./tofu.nix
    ];
  };
}