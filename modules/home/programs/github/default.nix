{ config, lib, pkgs, ... }:
let
  ghDashCfg = config.github.ghDash;

  ghDashSettings = lib.recursiveUpdate {
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
    theme.ui = {
      sectionsShowCount = true;
      table.compact = false;
    };
  } ghDashCfg.settings;
in {
  options.github.ghDash = {
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
      type = lib.types.attrs;
      default = { };
      description = "Additional gh-dash configuration merged over the shared defaults.";
    };
  };

  config = {
    programs.gh = {
      enable = true;
    };

    programs.gh-dash = {
      enable = true;
      settings = ghDashSettings;
    };

    catppuccin."gh-dash".enable = true;

    home.file.".local/scripts/gh-dash-pr-review" = {
      source = ./scripts/gh-dash-pr-review.sh;
      executable = true;
    };
  };
}
