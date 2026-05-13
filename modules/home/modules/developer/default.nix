{ lib, osConfig, ... }: {
  imports = lib.optionals (osConfig.homeProfiles.developer.enable or false) [
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
}
