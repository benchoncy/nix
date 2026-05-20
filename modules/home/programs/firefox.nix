{ config, lib, pkgs, ... }:
let
  firefoxCfg = config.programs.firefox;

  defaultToolbarExtensionEntries = [
    {
      extensionId = "uBlock0@raymondhill.net";
      area = "unified-extensions-area";
      priority = 100;
    }
    {
      extensionId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
      area = "unified-extensions-area";
      priority = 200;
    }
    {
      extensionId = "firefoxcolor@mozilla.com";
      area = "unified-extensions-area";
      priority = 300;
    }
    {
      extensionId = "{b5e0e8de-ebfe-4306-9528-bcc18241a490}";
      area = "unified-extensions-area";
      priority = 400;
    }
    {
      extensionId = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
      area = "nav-bar";
      priority = 100;
    }
    {
      extensionId = "languagetool-webextension@languagetool.org";
      area = "nav-bar";
      priority = 200;
    }
    {
      extensionId = "zotero@chnm.gmu.edu";
      area = "nav-bar";
      priority = 300;
    }
  ];

  composedToolbarExtensionEntries =
    defaultToolbarExtensionEntries ++ firefoxCfg.toolbarExtensionEntries;

  widgetIdForExtension = extensionId:
    let
      sanitizedExtensionId = lib.toLower (lib.foldl'
        (acc: char: lib.replaceStrings [ char ] [ "_" ] acc)
        extensionId
        [ "@" "." "{" "}" ]);
    in
    "${sanitizedExtensionId}-browser-action";

  toolbarExtensionEntriesByWidgetId = lib.foldl'
    (acc: entry:
      acc // {
        "${entry.widgetId}" = entry;
      })
    { }
    (map
      (entry: entry // {
        widgetId = widgetIdForExtension entry.extensionId;
      })
      composedToolbarExtensionEntries);

  sortedToolbarExtensionEntries = builtins.sort
    (a: b:
      if a.priority == b.priority then
        a.widgetId < b.widgetId
      else
        a.priority < b.priority)
    (builtins.attrValues toolbarExtensionEntriesByWidgetId);

  toolbarWidgetIdsForArea = area:
    map (entry: entry.widgetId) (lib.filter (entry: entry.area == area) sortedToolbarExtensionEntries);

  browserUiCustomizationState = {
    placements = {
      "widget-overflow-fixed-list" = [ ];
      "unified-extensions-area" = toolbarWidgetIdsForArea "unified-extensions-area";
      "nav-bar" = [
        "back-button"
        "forward-button"
        "stop-reload-button"
        "customizableui-special-spring1"
        "vertical-spacer"
        "urlbar-container"
        "customizableui-special-spring2"
        "downloads-button"
      ] ++ toolbarWidgetIdsForArea "nav-bar" ++ [
        "unified-extensions-button"
      ];
      "toolbar-menubar" = [ "menubar-items" ];
      TabsToolbar = [ "firefox-view-button" "tabbrowser-tabs" "new-tab-button" "alltabs-button" ];
      "vertical-tabs" = [ ];
      PersonalToolbar = [ "import-button" "personal-bookmarks" ];
    };
    seen = lib.unique ([
      "developer-button"
      "screenshot-button"
    ] ++ map (entry: entry.widgetId) sortedToolbarExtensionEntries);
    dirtyAreaCache = [ "nav-bar" "vertical-tabs" "PersonalToolbar" "toolbar-menubar" "TabsToolbar" "unified-extensions-area" ];
    currentVersion = 23;
    newElementCount = 6;
  };
in {
  options.programs.firefox.toolbarExtensionEntries = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        extensionId = lib.mkOption {
          type = lib.types.str;
          description = "Firefox extension id used to derive the toolbar widget id.";
        };

        area = lib.mkOption {
          type = lib.types.enum [ "nav-bar" "unified-extensions-area" ];
          description = "Toolbar area where the extension widget should be placed.";
        };

        priority = lib.mkOption {
          type = lib.types.int;
          description = "Deterministic ordering priority within the target toolbar area.";
        };
      };
    });
    default = [ ];
    description = "Mergeable Firefox toolbar extension placements used to build browser.uiCustomization.state. Later entries for the same extensionId override earlier ones.";
  };

  config = {
    programs.firefox = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then null else pkgs.firefox;
      languagePacks = lib.mkIf (!pkgs.stdenv.isDarwin) [ "en-GB" ];
      profiles.default = {
        search = {
          default = "ddg";
          force = true;
          engines = {
            duckduckgo = {
              metaData = {
                alias = "@ddg";
              };
            };
            google = {
              metaData = {
                alias = "@g";
              };
            };
            startpage = {
              metaData = {
                alias = "@sp";
              };
            };
            chatgpt = {
              name = "ChatGPT";
              urls = [{
                template = "https://chatgpt.com/?prompt={searchTerms}";
              }];
              definedAliases = [ "@gpt" ];
            };
            claude = {
              name = "Claude";
              urls = [{
                template = "https://claude.ai/new?q={searchTerms}";
              }];
              definedAliases = [ "@claude" ];
            };
            nixos = {
              name = "NixOS Packages";
              urls = [{
                template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              }];
              definedAliases = [ "@nix" ];
            };
            youtube = {
              name = "YouTube";
              urls = [{
                template = "https://www.youtube.com/results?search_query={searchTerms}";
              }];
              definedAliases = [ "@yt" ];
            };
            github = {
              name = "GitHub";
              urls = [{
                template = "https://github.com/search?q={searchTerms}";
              }];
              definedAliases = [ "@gh" ];
            };
          };
        };
        settings = {
          "browser.startup.homepage" = "https://duckduckgo.com";
          "browser.bookmarks.showMobileBookmarks" = true;
          "browser.uiCustomization.state" = builtins.toJSON browserUiCustomizationState;
          "browser.theme.follow-system-theme" = true;
        };
      };
      policies = {
        ExtensionSettings = {
          "zotero@chnm.gmu.edu" = {
            installation_mode = "force_installed";
            install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
            default_area = "navbar";
            pinned = true;
          };

          "languagetool-webextension@languagetool.org" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
            default_area = "navbar";
            pinned = true;
          };

          "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
            default_area = "navbar";
            pinned = true;
          };

          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };

          "{b5e0e8de-ebfe-4306-9528-bcc18241a490}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/granted/latest.xpi";
          };

          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          };

          "{189cac99-4ad6-461b-a410-4cb49821981b}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/zotero-scholar/latest.xpi";
          };

          "gdpr@cavi.au.dk" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/consent-o-matic/latest.xpi";
          };
        };
      };
    };
  };
}
