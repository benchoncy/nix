{ pkgs, ... }:
let
  signingProgram = if pkgs.stdenv.isDarwin then
    "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
  else
    "${pkgs._1password-gui}/share/1password/op-ssh-sign";
in {
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
      };
    };
  };
}
