{ lib, osConfig, ... }: {
  config = {
    ai.enable = lib.mkDefault (osConfig.ai.enable or false);
    ai.opencode.enable = lib.mkDefault (osConfig.ai.opencode.enable or false);
    ai.nvim.enable = lib.mkDefault (osConfig.ai.nvim.enable or false);
    ai.providers.githubCopilot.enable = lib.mkDefault (osConfig.ai.providers.githubCopilot.enable or false);
    ai.providers.supermaven.enable = lib.mkDefault (osConfig.ai.providers.supermaven.enable or false);
    ai.providers.openai.enable = lib.mkDefault (osConfig.ai.providers.openai.enable or false);
  };
}
