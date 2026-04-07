{ pkgs, ... }:

{
  advanced-tables = pkgs.callPackage ./advanced-tables.nix { };
  auto-link-title = pkgs.callPackage ./auto-link-title.nix { };
  remotely-save = pkgs.callPackage ./remotely-save.nix { };
  zotero-integration = pkgs.callPackage ./zotero-integration.nix { };
}
