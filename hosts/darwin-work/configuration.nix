{ pkgs, username, ... }: {

  imports = [
    ../../modules/shared
    ../../modules/darwin
  ];
  
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
                { app = "/Applications/Ghostty.app"; }
                { app = "/Applications/1Password.app"; }
                { app = "/Applications/Obsidian.app"; }
            ];
            persistent-others = [
                { folder = { path = "/Users/${username}/Downloads"; displayas = "stack"; }; }
            ];
        };
    };
  };
}
