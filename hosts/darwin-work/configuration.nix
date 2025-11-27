{ pkgs, system, username ... }: {

  imports = [
    ../../modules/shared
    ../../modules/darwin
  ];
  
  # Enable Home Manager Module
  home-manager.enable = true;

  environment.systemPackages = with pkgs; [
    # Place bespoke packages here if needed
  ];

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
