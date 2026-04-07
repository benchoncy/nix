# Obsidian Plugins

This directory contains Nix package definitions for Obsidian community plugins.

## Structure

```
plugins/
├── default.nix           # Imports all plugins via callPackage
├── advanced-tables.nix  # Plugin package definition
├── auto-link-title.nix  # Plugin package definition
├── remotely-save.nix    # Plugin package definition
└── zotero-integration.nix # Plugin package definition
```

## Adding a New Plugin

1. Create a new `.nix` file for the plugin (e.g., `my-plugin.nix`)

2. Define the package using `mkDerivation`:
   ```nix
   { pkgs, ... }:

   let
     version = "1.0.0";
   in
   pkgs.stdenv.mkDerivation {
     pname = "obsidian.plugins.my-plugin";
     inherit version;

     # Use unzip if plugin provides a ZIP release
     nativeBuildInputs = [ pkgs.unzip ];

     src = pkgs.fetchurl {
       url = "https://github.com/owner/my-plugin/releases/download/${version}/my-plugin.zip";
       sha256 = "sha256-...";
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
   ```

3. Add the plugin to `default.nix`:
   ```nix
   { pkgs, ... }:

   {
     my-plugin = pkgs.callPackage ./my-plugin.nix { };
     # ... existing plugins
   }
   ```

4. Add the plugin to the community plugins list in `../default.nix`:
   ```nix
   communityPlugins = [
     plugins.advanced-tables
     plugins.auto-link-title
     plugins.remotely-save
     plugins.zotero-integration
     plugins.my-plugin  # Add here
   ];
   ```

## Updating a Plugin

1. Update the `version` variable:
   ```nix
   let
     version = "2.0.0";  # New version
   in
   ```

2. Update the URL to use the new version:
   ```nix
   url = "https://github.com/owner/my-plugin/releases/download/${version}/...";
   ```

3. Get the new hash:
   ```bash
   nix hash-file --sri --type sha256 <(curl -sL "https://github.com/owner/my-plugin/releases/download/2.0.0/my-plugin.zip")
   ```

4. Update the hash in the `src` attribute.

## Removing a Plugin

1. Remove the import from `default.nix`
2. Remove the plugin from the `communityPlugins` list in `../default.nix`
3. Delete the plugin's `.nix` file

## Release Formats

### ZIP Release (use `unzip`)
```nix
nativeBuildInputs = [ pkgs.unzip ];
src = pkgs.fetchurl {
  url = "https://github.com/owner/repo/releases/download/${version}/plugin.zip";
  sha256 = "...";
};
unpackPhase = "unzip -q $src";
```

### Individual Files (no unpack)
```nix
src = pkgs.fetchurl {
  url = "https://github.com/owner/repo/releases/download/${version}/main.js";
  sha256 = "...";
  name = "main.js";
};
dontUnpack = true;
installPhase = ''
  mkdir -p $out
  cp $src $out/main.js
  cp ${pkgs.fetchurl {
    url = "https://github.com/owner/repo/releases/download/${version}/manifest.json";
    sha256 = "...";
  }} $out/manifest.json
'';
```

## Getting Hashes

For ZIP files:
```bash
nix hash-file --sri --type sha256 <(curl -sL "https://github.com/owner/repo/releases/download/version/file.zip")
```

For individual files:
```bash
nix hash-file --sri --type sha256 <(curl -sL "https://github.com/owner/repo/releases/download/version/main.js")
```

## Checking Available Releases

```bash
curl -sL https://api.github.com/repos/owner/repo/releases/latest | python3 -c "import sys,json; d=json.load(sys.stdin); print([a['name'] for a in d.get('assets',[])])"
```
