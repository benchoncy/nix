{ pkgs, ... }:

let
  version = "1.5.5";
in
pkgs.stdenv.mkDerivation {
  pname = "obsidian.plugins.auto-link-title";
  inherit version;

  nativeBuildInputs = [ pkgs.unzip ];

  src = pkgs.fetchurl {
    url = "https://github.com/zolrath/obsidian-auto-link-title/releases/download/${version}/obsidian-auto-link-title-${version}.zip";
    sha256 = "sha256-8GR5jLWkWMrLlOla8QLE2TfnJ5urdDY65CmVgI+6Quk=";
  };

  unpackPhase = "unzip -q $src";

  installPhase = ''
    dir=$(find . -mindepth 1 -maxdepth 1 -type d | head -1)
    mkdir -p $out
    cp "$dir/manifest.json" "$out/manifest.json"
    cp "$dir/main.js" "$out/main.js"
    if [ -f "$dir/styles.css" ]; then
      cp "$dir/styles.css" "$out/styles.css"
    fi
  '';
}
