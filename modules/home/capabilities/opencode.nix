{ config, lib, pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };
  cfg = config.opencode;

  finalConfig = lib.recursiveUpdate
    (lib.recursiveUpdate cfg.settings {
      mcp = cfg.mcp;
    })
    cfg.extraConfig;
in {
  options.opencode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to manage OpenCode configuration files.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = jsonFormat.type;
      };
      default = { };
      description = "Base OpenCode configuration, excluding MCP server definitions.";
    };

    mcp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        freeformType = jsonFormat.type;

        options.enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether this MCP server should be enabled in the generated config.";
        };
      });
      default = { };
      description = "Layered MCP server definitions keyed by server name.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.submodule {
        freeformType = jsonFormat.type;
      };
      default = { };
      description = "Final OpenCode config overrides merged after settings and MCP definitions.";
    };
  };

  config = lib.mkIf cfg.enable {
    opencode.settings = {
      "$schema" = lib.mkDefault "https://opencode.ai/config.json";
      autoupdate = lib.mkDefault false;
      share = lib.mkDefault "disabled";
      watcher.ignore = lib.mkDefault [
        "**/.git/**"
        "**/node_modules/**"
        "**/.cache/**"
        "**/dist/**"
      ];
      permission.bash = lib.mkDefault {
        "rm" = "ask";
        "rm *" = "ask";
        "git reset --hard*" = "deny";
        "git checkout --*" = "deny";
        "git clean -fd*" = "deny";
        "git clean -fdx*" = "deny";
        "git push -f*" = "deny";
        "git push --force*" = "deny";
        "git push --force-with-lease*" = "deny";
      };
    };

    opencode.mcp.context7 = lib.mkDefault {
      type = "remote";
      url = "https://mcp.context7.com/mcp";
      enabled = true;
    };

    opencode.mcp.gh_grep = lib.mkDefault {
      type = "remote";
      url = "https://mcp.grep.app";
      enabled = true;
    };

    opencode.mcp.obsidian = lib.mkDefault {
      type = "local";
      command = [ "uvx" "mcp-obsidian" ];
      environment = {
        OBSIDIAN_API_KEY = "{env:OBSIDIAN_API_KEY}";
        OBSIDIAN_HOST = "{env:OBSIDIAN_HOST}";
        OBSIDIAN_PORT = "{env:OBSIDIAN_PORT}";
      };
      enabled = true;
    };

    opencode.mcp.playwright = lib.mkDefault {
      type = "local";
      command = [ "npx" "@playwright/mcp@latest" ];
      enabled = false;
    };

    opencode.mcp.zotero = lib.mkDefault {
      type = "local";
      command = [ "uvx" "zotero-mcp" ];
      environment = {
        ZOTERO_LOCAL = "true";
      };
      enabled = false;
    };

    home.file.".config/opencode/opencode.jsonc".text = builtins.toJSON finalConfig;
    home.file.".config/opencode/tui.jsonc".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/tui.json";
      theme = "catppuccin-macchiato";
    };
  };
}
