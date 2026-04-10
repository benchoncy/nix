{ pkgs, ... }:

let
  version = "0.3.8";
in
pkgs.stdenv.mkDerivation {
  pname = "obsidian.plugins.languagetool-integration";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/Clemens-E/obsidian-languagetool-plugin/releases/download/${version}/main.js";
    sha256 = "sha256-EUszCHOqyT9+U6aHDD5W+c9yVDmMKDMG67zBaK8UB64=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp $src $out/main.js
    cp ${pkgs.fetchurl {
      url = "https://github.com/Clemens-E/obsidian-languagetool-plugin/releases/download/${version}/manifest.json";
      sha256 = "sha256-OvkqfLyNcGn2JCO4arvgOEvLrnzmFCfFkAKqKzPdDns=";
    }} $out/manifest.json
    cp ${pkgs.fetchurl {
      url = "https://github.com/Clemens-E/obsidian-languagetool-plugin/releases/download/${version}/styles.css";
      sha256 = "sha256-8RnXm7GrNJ/jyJL7At89RexPIj7VNHlEvjMn5LYkmFo=";
    }} $out/styles.css
  '';
}