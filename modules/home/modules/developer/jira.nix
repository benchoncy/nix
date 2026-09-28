args@{ config, lib, pkgs, ... }:
let
  osConfig = args.osConfig or {};
  profiles = args.profileConfig or (osConfig.homeProfiles or config.homeProfiles);
in {
  config = lib.mkIf (profiles.developer.jira.enable or false) {
    home.packages = with pkgs; [
      jira-cli-go
      jiratui
    ];

    programs.zsh.shellAliases = {
      j = "jira";
      jl = "jira issue list";
      jo = "jiratui ui";
      joo = "jira open";
    };
  };
}
