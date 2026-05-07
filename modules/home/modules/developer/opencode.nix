{ config, lib, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.opencode.enable {
    home.file = {
      ".config/opencode/agents".source = ./config/agents;
      ".config/opencode/commands".source = ./config/commands;
      ".config/opencode/skills".source = ./config/skills;
    };
  };
}