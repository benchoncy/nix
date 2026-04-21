{ lib, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-GB" ];
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
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"firefoxcolor_mozilla_com-browser-action\",\"_b5e0e8de-ebfe-4306-9528-bcc18241a490_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"zotero_chnm_gmu_edu-browser-action\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"ublock0_raymondhill_net-browser-action\",\"_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action\",\"firefoxcolor_mozilla_com-browser-action\",\"_b5e0e8de-ebfe-4306-9528-bcc18241a490_-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"languagetool-webextension_languagetool_org-browser-action\",\"zotero_chnm_gmu_edu-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":6}";
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
}
