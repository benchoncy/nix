# Fix zoxide cd alias conflict

## Goal
Resolve the zoxide config error caused by conflicting `cd` alias.

## Scope
- `.zshrc` and `.bashrc`: add `--cmd cd` to zoxide init
- `aliases.sh`: remove redundant `alias cd="z"`

## Non-goals
- No other shell config changes

## Requirements and constraints
- `z` command must continue to work (provided by zoxide init)
- `cd` must work as native directory change AND be hooked by zoxide
- Both zsh and bash must be fixed

## Design intent
zoxide provides `--cmd cd` to hook the `cd` builtin, so `cd` automatically gets zoxide behavior without needing a manual alias. The manual `alias cd="z"` conflicts with this hook mechanism and causes config errors.

## Validation
- `nix flake check` passes
- Manual rebuild and shell test: `cd`, `z`, and `z -` all work correctly

## Task breakdown
1. Add `--cmd cd` to `zoxide init zsh` in `.zshrc`
2. Add `--cmd cd` to `zoxide init bash` in `.bashrc`
3. Remove `alias cd="z"` and its comment from `aliases.sh`
