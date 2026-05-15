{ config, lib, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.opencode.enable {
    home.file = {
      ".config/opencode/agents".source = ./opencode/config/agents;
      ".config/opencode/commands".source = ./opencode/config/commands;
      ".config/opencode/skills".source = ./opencode/config/skills;
    };
  };
}
