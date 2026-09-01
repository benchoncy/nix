args@{ config, lib, ... }:
let
  osConfig = args.osConfig or {};
  profiles = args.profileConfig or (osConfig.homeProfiles or {});
in {
  imports = lib.optionals (profiles.developer.enable or false) [
    ./bruno.nix
    ./python.nix
    ./github.nix
    ./opencode.nix
    ./aws.nix
    ./go.nix
    ./rust.nix
    ./lua.nix
    ./containers.nix
    ./vms.nix
    ./javascript.nix
    ./tofu.nix
  ];
}
