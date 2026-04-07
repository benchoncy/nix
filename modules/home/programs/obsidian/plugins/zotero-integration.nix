{ pkgs, ... }:

let
  version = "3.2.1";
in
pkgs.stdenv.mkDerivation {
  pname = "obsidian.plugins.zotero-integration";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/obsidian-community/obsidian-zotero-integration/releases/download/${version}/main.js";
    sha256 = "sha256-QVgkSNeQ17mkaRwA/0bdoJsPO76gLInQk8xAGN/BQDI=";
    name = "main.js";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp $src $out/main.js
    cp ${pkgs.fetchurl {
      url = "https://github.com/obsidian-community/obsidian-zotero-integration/releases/download/${version}/manifest.json";
      sha256 = "sha256-wY8lKh+SEIVGe6gj19Jyo2nmXj8wAR9vlViuQgGROVw=";
      name = "manifest.json";
    }} $out/manifest.json
    cp ${pkgs.fetchurl {
      url = "https://github.com/obsidian-community/obsidian-zotero-integration/releases/download/${version}/styles.css";
      sha256 = "sha256-PqaYiqtsRRg9xpyF1Yc3h9y70NdiZPIRwHuEAPnbwGo=";
      name = "styles.css";
    }} $out/styles.css
  '';
}
