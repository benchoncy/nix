{ lib, pkgs, ... }: {
  programs.firefox = {
    enable = if pkgs.stdenv.isDarwin then false else true;
    package = if pkgs.stdenv.isDarwin then pkgs.firefox-bin else pkgs.firefox;
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
      };
    };
  };
}
