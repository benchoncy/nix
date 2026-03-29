{ ... }: {
  ai = {
    enable = true;

    opencode = {
      enable = true;
    };

    nvim = {
      enable = false;
    };

    providers = {
      githubCopilot.enable = false;
      supermaven.enable = false;
      openai.enable = false;
    };
  };

  opencode.mcp.work-docs = {
    type = "remote";
    url = "https://mcp.<work-domain>/mcp";
    oauth = { };
    enabled = true;
  };

  home.file.".aws/config" = {
    source = ../../home-files/work/.aws/config;
  };

  home.file.".gitconfig-work".text = ''
    [user]
        email = <work-email>
    [commit]
        gpgSign = false
  '';

  home.file.".config/shell/tools/work-ticket.sh" = {
    source = ../../home-files/work/.config/shell/tools/work-ticket.sh;
  };

  github.tooling = {
    enable = true;
    ghDash.host = "<work-git-host>";
  };

  programs.git.includes = [
    {
      condition = "gitdir:~/Projects/<work-git-host>/";
      path = "~/.gitconfig-work";
    }
  ];
}
