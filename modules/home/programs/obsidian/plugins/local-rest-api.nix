{ pkgs, ... }:

let
  version = "3.6.1";
in
pkgs.stdenv.mkDerivation {
  pname = "obsidian.plugins.local-rest-api";
  inherit version;

  nativeBuildInputs = [ pkgs.unzip ];

  src = pkgs.fetchurl {
    url = "https://github.com/coddingtonbear/obsidian-local-rest-api/releases/download/${version}/obsidian-local-rest-api-${version}.zip";
    sha256 = "sha256-ZrETCBEFDjHtQeRS3t0hFmMx24f4Wl1oDfaZKpelsqk=";
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