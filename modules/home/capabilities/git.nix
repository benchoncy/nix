{ pkgs, ... }:
let
  signingProgram = if pkgs.stdenv.isDarwin then
    "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
  else
    "${pkgs._1password-gui}/share/1password/op-ssh-sign";
in {
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Catppuccin Macchiato";
        plus-style = "syntax #1E2030";
        plus-emph-style = "syntax bold #A6DA95";
        minus-style = "syntax #1E2030";
        minus-emph-style = "syntax bold #ED8796";
        hunk-header-style = "syntax #8AADF4";
        hunk-header-decoration-style = "#494D64 ul";
        file-style = "bold #CAD3F5";
        file-decoration-style = "#8AADF4";
        commit-style = "bold #C6A0F6";
        commit-decoration-style = "#C6A0F6";
      };
    };
    settings = {
      user = {
        name = "Ben Stuart";
        email = "ben@benstuart.ie";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWgRvHskkugDphe4+YPRUe3ztq0cOYV9hDlYMG7+roi";
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
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
}
