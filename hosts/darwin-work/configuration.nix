{ pkgs, system, ... }:
let
  username = "bstuart";
in {
  nixpkgs.config.allowUnfree = true;

  # Define system packages
  environment.systemPackages = with pkgs; [
    ghostty-bin
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  system = {
    primaryUser = username; 
    stateVersion = 6; 
    defaults = {
        # Configure MacOS Dock
        dock = {
            autohide = true;
            orientation = "bottom";
            mineffect = "genie";
            magnification = true;
            launchanim = true;
            persistent-apps = [
                { app = "/Applications/Google Chrome.app"; }
                { app = "/Applications/Slack.app"; }
                { app = "/Applications/Nix Apps/Ghostty.app"; }
                { app = "/Applications/Nix Apps/1Password.app"; }
                { app = "/Applications/Nix Apps/Obsidian.app"; }
            ];
            persistent-others = [
                { folder = { path = "/Users/${username}/Downloads"; displayas = "stack"; }; }
            ];
        };
    };
  };
}
