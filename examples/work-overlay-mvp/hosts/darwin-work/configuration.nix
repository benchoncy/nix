{ username, ... }: {
  homeProfiles = {
    ai = {
      enable = true;
      opencode.enable = true;
      nvim.enable = false;
      providers = {
        githubCopilot.enable = false;
        supermaven.enable = false;
        openai.enable = false;
      };
    };
    developer.enable = true;
    developer.github.enable = true;
    developer.opencode.enable = true;
  };

  home-manager.users.${username}.imports = [
    ../../modules/home/default.nix
  ];

  system = {
    primaryUser = username;
    stateVersion = 6;
  };
}
