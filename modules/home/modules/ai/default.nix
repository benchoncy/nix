{ config, lib, osConfig, ... }:
let
  cfg = osConfig.homeProfiles.ai;
in {
  config = lib.mkIf cfg.enable {
    home.file.".config/userdata/ai-policy.json".text = builtins.toJSON {
      enable = cfg.enable;
      opencode = {
        enable = cfg.opencode.enable;
      };
      nvim = {
        enable = cfg.nvim.enable;
      };
      providers = {
        githubCopilot.enable = cfg.providers.githubCopilot.enable;
        supermaven.enable = cfg.providers.supermaven.enable;
        openai.enable = cfg.providers.openai.enable;
      };
    };

    opencode.enable = cfg.enable && cfg.opencode.enable;
  };
}