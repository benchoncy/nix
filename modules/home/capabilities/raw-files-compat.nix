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
      target = ".config/diffnav/config.yml";
      source = commonRoot + "/.config/diffnav/config.yml";
    }
    {
      target = ".aws/cli/alias";
      source = commonRoot + "/.aws/cli/alias";
    }
    {
      target = ".config/opencode/agents/peer-review.md";
      source = commonRoot + "/.config/opencode/agents/peer-review.md";
    }
    {
      target = ".config/opencode/commands/consensus-plan.md";
      source = commonRoot + "/.config/opencode/commands/consensus-plan.md";
    }
    {
      target = ".config/opencode/commands/open-pr.md";
      source = commonRoot + "/.config/opencode/commands/open-pr.md";
    }
    {
      target = ".config/opencode/skills/consensus-planning/SKILL.md";
      source = commonRoot + "/.config/opencode/skills/consensus-planning/SKILL.md";
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
    ".config/gh-dash/config.yml"
    ".config/opencode/opencode.jsonc"
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
