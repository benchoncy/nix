{ pkgs, system, ... }:
let
  username = "bstuart";
in {
  nixpkgs.hostPlatform = system;

  environment.systemPackages = with pkgs; [
] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  nix = {
    enable = false;
    settings = {
        experimental-features = "nix-command flakes";
    };
  };

  system = {
    primaryUser = username;
    stateVersion = 6;
    defaults = {
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
