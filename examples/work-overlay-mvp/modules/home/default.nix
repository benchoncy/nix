{ ... }: {
  # Enable AI and developer profiles
  homeProfiles = {
    ai = {
      enable = true;
      opencode.enable = true;
      nvim.enable = false;
      providers = {
        githubCopilot.enable = false;
        supermaven.enable = false;
        openai.enable = false;
      };
    };
    developer.enable = true;
    developer.github.enable = true;
    developer.opencode.enable = true;
  };

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

  # gh-dash configuration for work GitHub host
  # Note: requires homeProfiles.developer.github.enable = true
  github.ghDash.host = "<work-git-host>";

  programs.git.includes = [
    {
      condition = "gitdir:~/Projects/<work-git-host>/";
      path = "~/.gitconfig-work";
    }
  ];
}