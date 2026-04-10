{ pkgs, ... }:

{
  advanced-tables = pkgs.callPackage ./advanced-tables.nix { };
  auto-link-title = pkgs.callPackage ./auto-link-title.nix { };
  languagetool-integration = pkgs.callPackage ./languagetool-integration.nix { };
  local-rest-api = pkgs.callPackage ./local-rest-api.nix { };
  remotely-save = pkgs.callPackage ./remotely-save.nix { };
  zotero-integration = pkgs.callPackage ./zotero-integration.nix { };
}
