{ config, lib, pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  ghCfg = config.github.tooling;
  ghDashCfg = ghCfg.ghDash;

  ghDashConfig = lib.recursiveUpdate {
    pager.diff = "diffnav";
    repoPaths = {
      ":owner/:repo" = "~/Projects/${ghDashCfg.host}/:owner/:repo.tree/${ghDashCfg.worktree}";
    };
    theme = {
      ui = {
        sectionsShowCount = true;
        table.compact = false;
      };
      colors = {
        text = {
          primary = "#CAD3F5";
          secondary = "#8AADF4";
          inverted = "#181926";
          faint = "#A5ADCB";
          warning = "#EED49F";
          success = "#A6DA95";
        };
        background.selected = "#363A4F";
        border = {
          primary = "#8AADF4";
          secondary = "#C6A0F6";
          faint = "#494D64";
        };
      };
    };
  } ghDashCfg.settings;
in {
  options = {
    github.tooling.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GitHub CLI tooling packages.";
    };

    github.tooling.ghDash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to manage the gh-dash configuration file.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "github.com";
        description = "Git host used for gh-dash repo path resolution.";
      };

      worktree = lib.mkOption {
        type = lib.types.str;
        default = "main";
        description = "Worktree directory name used in gh-dash repo paths.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = yamlFormat.type;
        };
        default = { };
        description = "Additional gh-dash configuration merged over the shared defaults.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf ghCfg.enable {
      programs.gh = {
        enable = true;
        extensions = with pkgs; [ gh-dash ];
      };
    })

    (lib.mkIf ghDashCfg.enable {
      xdg.configFile."gh-dash/config.yml".text = ''
        # yaml-language-server: $schema=https://gh-dash.dev/schema.json
        ${lib.generators.toYAML { } ghDashConfig}
      '';
    })
  ];
}
