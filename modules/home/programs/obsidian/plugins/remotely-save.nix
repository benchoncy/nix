{ pkgs, ... }:

let
  version = "0.5.25";
in
pkgs.stdenv.mkDerivation {
  pname = "obsidian.plugins.remotely-save";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/remotely-save/remotely-save/releases/download/${version}/main.js";
    sha256 = "sha256-s6+9J/FRiLl4RhjJWGB4abqkNNwKvPByd0+ZNiwR+gQ=";
    name = "main.js";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp $src $out/main.js
    cp ${pkgs.fetchurl {
      url = "https://github.com/remotely-save/remotely-save/releases/download/${version}/manifest.json";
      sha256 = "sha256-cdnAthYAPzppaIDnqogpblsxVVdX6TOhLSkAuWxMqpA=";
      name = "manifest.json";
    }} $out/manifest.json
    cp ${pkgs.fetchurl {
      url = "https://github.com/remotely-save/remotely-save/releases/download/${version}/styles.css";
      sha256 = "sha256-h1hOfVOMpYxSevuyYlsJ6igryue/eEt8zjPKkung37M=";
      name = "styles.css";
    }} $out/styles.css
  '';
}
