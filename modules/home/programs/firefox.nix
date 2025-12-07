{ lib, pkgs, ... }: {
  programs.firefox = {
    enable = if pkgs.stdenv.isDarwin then false else true;
    languagePacks = [ "en-GB" ];
    profiles.default = {
      search = {
        default = "ddg";
        force = true;
      };
      settings = {
        "browser.startup.homepage" = "https://duckduckgo.com";
        "browser.bookmarks.showMobileBookmarks" = true;
      };
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          firefox-color
          onepassword-password-manager
          ublock-origin
          granted
          vimium
        ];
      };
    };
  };
}
