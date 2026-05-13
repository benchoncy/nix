{ config, lib, pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  ghDashCfg = config.github.ghDash;

  ghDashConfig = lib.recursiveUpdate {
    pager.diff = "diffnav";
    keybindings.prs = [
      {
        key = "R";
        name = "review";
        command = "\"$HOME/.local/scripts/gh-dash-pr-review\" \"{{.RepoName}}\" \"{{.RepoPath}}\" \"{{.PrNumber}}\"";
      }
    ];
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
          secondary = "#8ADF4";
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
  options.github.ghDash = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
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

  config = lib.mkIf ghDashCfg.enable {
    home.file.".local/scripts/gh-dash-pr-review" = {
      source = ../modules/developer/github/scripts/gh-dash-pr-review.sh;
      executable = true;
    };

    xdg.configFile."gh-dash/config.yml".text = ''
      # yaml-language-server: $schema=https://gh-dash.dev/schema.json
      ${lib.generators.toYAML { } ghDashConfig}
    '';
  };
}
