{ lib, ... }:
let
  inherit (lib) hasPrefix listToAttrs nameValuePair optionalAttrs unique;

  commonRoot = ../../../home-files/common;

  mkEntry = entry:
    nameValuePair entry.target ({
      source = entry.source;
    }
    // optionalAttrs (entry ? recursive && entry.recursive) {
      recursive = true;
    }
    // optionalAttrs (entry ? executable && entry.executable) {
      executable = true;
    });

  commonRawDirs = [
    {
      target = ".config/nvim";
      source = commonRoot + "/.config/nvim";
      recursive = true;
    }
    {
      target = ".config/opencode";
      source = commonRoot + "/.config/opencode";
      recursive = true;
    }
    {
      target = ".config/shell";
      source = commonRoot + "/.config/shell";
      recursive = true;
    }
  ];

  commonRawFiles = [
    {
      target = ".zshrc";
      source = commonRoot + "/.zshrc";
    }
    {
      target = ".bashrc";
      source = commonRoot + "/.bashrc";
    }
    {
      target = ".config/starship.toml";
      source = commonRoot + "/.config/starship.toml";
    }
    {
      target = ".aws/cli/alias";
      source = commonRoot + "/.aws/cli/alias";
    }
  ];

  commonExecutableFiles = [
    {
      target = ".local/scripts/git-afforester";
      source = commonRoot + "/.local/scripts/git-afforester";
      executable = true;
    }
    {
      target = ".local/scripts/tmux-sessionizer";
      source = commonRoot + "/.local/scripts/tmux-sessionizer";
      executable = true;
    }
    {
      target = ".local/scripts/tmux-windowizer";
      source = commonRoot + "/.local/scripts/tmux-windowizer";
      executable = true;
    }
  ];

  rawEntries = commonRawDirs
    ++ commonRawFiles
    ++ commonExecutableFiles;

  rawFiles = listToAttrs (map mkEntry rawEntries);
  targets = map (entry: entry.target) rawEntries;

  reservedTargets = [
    ".gitconfig"
    ".ssh/config"
    ".aws/config"
    ".config/ghostty/config"
  ];

  conflictingTargets = builtins.filter (
    target:
    builtins.any (
      reservedTarget: target == reservedTarget || hasPrefix "${target}/" reservedTarget
    ) reservedTargets
  ) targets;

  duplicateTargets = builtins.filter (
    target: builtins.length (builtins.filter (candidate: candidate == target) targets) > 1
  ) targets;
in {
  assertions = [
    {
      assertion = conflictingTargets == [ ];
      message = "home-files compatibility layer cannot manage reserved targets: ${builtins.concatStringsSep ", " conflictingTargets}";
    }
    {
      assertion = builtins.length targets == builtins.length (unique targets);
      message = "home-files compatibility layer has duplicate targets: ${builtins.concatStringsSep ", " (unique duplicateTargets)}";
    }
  ];

  home.file = rawFiles;
}
