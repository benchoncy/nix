{ config, lib, ... }:
let
  cfg = config.ai;
in {
  options.ai = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether machine-managed AI tooling and integrations are enabled.";
    };

    opencode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install and configure OpenCode on this machine.";
      };
    };

    nvim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether AI Neovim integrations are enabled on this machine.";
      };

    };

    providers = {
      githubCopilot.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether GitHub Copilot is allowed on this machine.";
      };

      supermaven.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Supermaven is allowed on this machine.";
      };

      openai.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether OpenAI is allowed on this machine.";
      };
    };
  };

  config = {
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
