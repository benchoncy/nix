{ config, lib, pkgs, osConfig, ... }: {
  config = lib.mkIf osConfig.homeProfiles.developer.javascript.enable {
    home.packages = with pkgs; [
      fnm
      nodejs_24
      pnpm
    ];

    programs.zsh.initContent = lib.mkAfter ''
      if command -v fnm >/dev/null 2>&1; then
        eval "$(fnm env --use-on-cd --shell zsh)"
      fi
    '';
  };
}
