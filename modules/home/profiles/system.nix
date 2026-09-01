{ inputs, ... }: {
  imports = [
    ./base.nix
    inputs.plasma-manager.homeModules.plasma-manager
    ../modules
  ];
}
