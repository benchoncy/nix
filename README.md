# Nix Configurations

This repository contains Nix configurations for target systems with the intent of creating a fully reproducible environment. The configuration aims to be used with NixOS or Nix on other Unix systems to produce my development environment across different machines.

# Usage

## NixOS

To use this configuration on NixOS, follow these steps:
1. Follow the [NixOS installation instructions](https://nixos.org/manual/nixos/stable/index.html#sec-installation) to install NixOS
2. Follow the [wiki instructions](https://nixos.wiki/wiki/Displaylink) to prefetch the DisplayLink non-free blob.
3. use `sudo nixos-rebuild switch --flake ./` to create a new configuration

## MacOS (Darwin)
(Updated ~Nov 2025, see [nix-darwin](https://github.com/nix-darwin/nix-darwin))

To use this configuration on MacOS, follow these steps:
1. Follow the Determinate Systems [instructions](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer) to install Nix
2. For a first time setup, use `sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch --flake ./` or `sudo darwin-rebuild switch --flake ./` thereafter.

# Development

## Testing Changes
Run `nix flake check` to test changes made to the flake before committing or initiating a rebuild.
