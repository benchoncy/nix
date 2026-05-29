{ pkgs, ... }:
let
  zoteroConfigRoot = if pkgs.stdenv.isDarwin then
    "Library/Application Support/Zotero"
  else
    ".zotero/zotero";

  zoteroProfilePath = if pkgs.stdenv.isDarwin then
    "Profiles/default"
  else
    "default";

  betterBibtex = pkgs.fetchurl {
    url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v9.0.27/zotero-better-bibtex-9.0.27.xpi";
    hash = "sha256-r6W6hbIYd8mZrYklTNIAp76js5XpEPI3mGZU6ryzxys=";
  };

  profileRoot = "${zoteroConfigRoot}/${zoteroProfilePath}";
in
{
  home.packages = [ pkgs.zotero ];

  home.file = {
    "${zoteroConfigRoot}/profiles.ini".text = ''
      [General]
      StartWithLastProfile=1
      Version=2

      [Profile0]
      Name=default
      IsRelative=1
      Path=${zoteroProfilePath}
      Default=1
    '';

    "${profileRoot}/user.js".text = ''
      user_pref("app.update.auto", false);
      user_pref("app.update.enabled", false);
      user_pref("extensions.autoDisableScopes", 0);
      user_pref("extensions.enabledScopes", 15);
      user_pref("extensions.update.autoUpdateDefault", false);
      user_pref("extensions.update.enabled", false);
      user_pref("extensions.zotero.translators.better-bibtex.citekeyFormat", "[auth:lower][shorttitle3_3][year]");
    '';

    "${profileRoot}/extensions/better-bibtex@iris-advies.com.xpi".source = betterBibtex;
  };
}
