{ config, pkgs, ... }:
let
  signingProgram = if pkgs.stdenv.isDarwin then
    "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
  else
    "${pkgs._1password-gui}/share/1password/op-ssh-sign";
in {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
      line-numbers-left-style = "#8AADF4";
      line-numbers-right-style = "#8AADF4";
      line-numbers-minus-style = "#EE99A0";
      line-numbers-plus-style = "#A6DA95";
      line-numbers-zero-style = "#6E738D";
      syntax-theme = "Catppuccin Macchiato";
      plus-style = "syntax #1E2030";
      plus-emph-style = "syntax bold #294436";
      minus-style = "syntax #1E2030";
      minus-emph-style = "syntax bold #4B2C3A";
      hunk-header-style = "syntax #8AADF4";
      hunk-header-decoration-style = "#494D64 ul";
      file-style = "bold #CAD3F5";
      file-decoration-style = "#8AADF4";
      commit-style = "bold #C6A0F6";
      commit-decoration-style = "#C6A0F6";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ben Stuart";
        email = "ben@benstuart.ie";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWgRvHskkugDphe4+YPRUe3ztq0cOYV9hDlYMG7+roi";
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
        excludesfile = "${config.xdg.configHome}/git/ignore";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgSign = true;
      gpg.format = "ssh";
      "gpg \"ssh\"".program = signingProgram;
      alias = {
        hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
        af = "!git-afforester";
        diffnav = "!f() { git diff \"$@\" | diffnav; }; f";
      };
    };
  };

  xdg.configFile."git/ignore".text = ''
    .ansible/
  '';
}
