{ pkgs, system, ... }: {
  environment.systemPackages = with pkgs; [
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  nix = {
    enable = false;
    settings = {
        experimental-features = "nix-command flakes";
    };
  };

  system = {
    stateVersion = 6;
  };
  
  nixpkgs.hostPlatform = system;
}
