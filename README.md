# Nix Configurations

This repository contains Nix configurations for target systems with the intent of creating a fully reproducible environment. The configuration aims to be used with NixOS or Nix on other Unix systems to produce my development environment across different machines.

# Usage

## NixOS

To use this configuration on NixOS, follow these steps:
1. Follow the [NixOS installation instructions](https://nixos.org/manual/nixos/stable/index.html#sec-installation) to install NixOS
2. Follow the [wiki instructions](https://nixos.wiki/wiki/Displaylink) to prefetch the DisplayLink non-free blob.
3. use `make nixos-rebuild` to create a new configuration

## MacOS (Darwin)
(Updated ~Nov 2025, see [nix-darwin](https://github.com/nix-darwin/nix-darwin))

To use this configuration on MacOS, follow these steps:
1. Follow the Determinate Systems [instructions](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer) to install Nix
2. For a first time setup, use `sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch --flake ./`.
3. Once the local private work repo exists at the configured path, use `sudo darwin-rebuild switch --impure --flake "path:$PWD#bstuart-mbp-m1pro"` or `make darwin-rebuild` thereafter.

# Development

## Testing Changes
Run `nix flake check` to test changes made to the flake before committing or initiating a rebuild.

## Home Manager Only

The flake now exposes standalone Home Manager outputs for dotfiles-only workflows.

- `home-manager switch --impure --flake "path:$PWD#bstuart-mbp-m1pro-home"`
- `home-manager switch --flake .#nixos-bstuart-home`

The work Home Manager output expects a local private work module checkout at the host-configured path.
Because that work module is local and intentionally ignored, work-only `darwin-rebuild` and `home-manager` runs should use `path:$PWD` and `--impure`.

## Raw Dotfiles

The repo supports raw dotfile copying through an explicit Home Manager manifest.

- shared raw files live under `home-files/common/`
- raw ownership is declared in `modules/home/capabilities/raw-files-compat.nix`
- prefer whole app directories under `.config/<app>` instead of one giant `.config` mapping
- keep reserved/generated files like `.gitconfig`, `.ssh/config`, `.aws/config`, and `.config/ghostty/config` in Home Manager modules rather than raw copies

## Migration Caveats

The current migration plan intentionally does not do a few things yet:

- there is no separate personal flake repo yet; this repo remains the shared base
- the private work config is not cloned at activation time and must exist locally on work machines
- not every dotfile needs to become a Nix/Home Manager option; raw file copying remains a supported path
- some app configs are expected to stay as raw files initially and move into Home Manager only when it is useful

## Private Work Overlay

Work-specific configuration is expected to live in a separate local repo that exports a Home Manager module.

- hosts opt in with `my.work.enable = true`
- hosts point at the local repo with `my.work.repoPath = "/absolute/path/to/private/work/repo"`
- the private repo should export `modules/home/default.nix`

If you need to recreate a minimal private work repo quickly, use `examples/work-overlay-mvp/` as a generic starting point.
It is intentionally organization-neutral and shows the minimum shape for work-only Git, AWS, and shell-tool overrides.
