{ pkgs, ... }:

let
  version = "0.22.1";
in
pkgs.stdenv.mkDerivation {
  pname = "obsidian.plugins.advanced-tables";
  inherit version;

  nativeBuildInputs = [ pkgs.unzip ];

  src = pkgs.fetchurl {
    url = "https://github.com/tgrosinger/advanced-tables-obsidian/releases/download/${version}/table-editor-obsidian-${version}.zip";
    sha256 = "sha256-W+uyUj4JwPGLWFGbppdrYqF5/640ceqqwCsz9IHNHLw=";
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
