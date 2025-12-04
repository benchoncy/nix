{ ... }: {
  programs.firefox = {
    enable = true;
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
