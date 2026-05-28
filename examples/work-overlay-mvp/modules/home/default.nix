{ lib, options, ... }:
let
  hasGhDashOptions =
    options ? github
    && options.github ? ghDash
    && options.github.ghDash ? host;
in {
  config = lib.mkMerge [
    {
      opencode.enable = true;

      # Work-only OpenCode MCP servers
      opencode.mcp.work-docs = {
        type = "remote";
        url = "https://mcp.<work-domain>/mcp";
        oauth = { };
        enabled = true;
      };

      # AWS config (work-specific)
      home.file.".aws/config" = {
        source = ./aws/config/cli/alias;
      };

      # Work git config
      home.file.".gitconfig-work".text = ''
        [user]
            email = <work-email>
        [commit]
            gpgSign = false
      '';

      # Work-specific shell tools
      home.file.".config/shell/tools/work-ticket.sh" = {
        source = ./shell/tools/work-ticket.sh;
      };

      programs.git.includes = [
        {
          condition = "gitdir:~/Projects/<work-git-host>/";
          path = "~/.gitconfig-work";
        }
      ];
    }

    (lib.optionalAttrs hasGhDashOptions {
      # gh-dash configuration for work GitHub host when GitHub tooling is enabled.
      github.ghDash.host = "<work-git-host>";
    })
  ];
}
