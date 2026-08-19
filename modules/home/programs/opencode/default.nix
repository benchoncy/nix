{ lib, pkgs, ... }:
let
  opencodeSessionizer = pkgs.writeShellScriptBin "opencode-sessionizer" ''
    if ! selected="$(${lib.getExe pkgs.opencode} session list --format json \
      | ${lib.getExe pkgs.jq} -r '.[] | [
          (.updated / 1000 | localtime | strftime("%Y-%m-%d %H:%M")),
          (.title // "Untitled"),
          (.directory // ""),
          .id
        ] | @tsv' \
      | ${lib.getExe pkgs.fzf} \
          --delimiter=$'\t' \
          --with-nth=1,2,3 \
          --prompt='opencode sessions> ' \
          --header='Last used | Title | Directory')"; then
      exit 0
    fi

    if [ -z "$selected" ]; then
      exit 0
    fi

    session_id="$(printf '%s\n' "$selected" | ${pkgs.coreutils}/bin/cut -f4)"

    if [ -z "$session_id" ]; then
      exit 1
    fi

    exec ${lib.getExe pkgs.opencode} --session "$session_id"
  '';
in {
  config = {
    home.packages = with pkgs; [
      opencode
      opencodeSessionizer
      rtk
      gopls
      rust-analyzer
      clang-tools
      bash-language-server
      typescript-language-server
      vscode-langservers-extracted
      marksman
      taplo
      tofu-ls
      ruff
      ty
    ];

    programs.opencode = {
      enable = true;
      settings = {
        "$schema" = "https://opencode.ai/config.json";
        autoupdate = false;
        plugin = [
          "@tarquinen/opencode-dcp"
          "@slkiser/opencode-quota"
        ];
        share = "disabled";
        lsp = {
          pyright.disabled = true;
          terraform.disabled = true;

          ruff = {
            command = [ "ruff" "server" ];
            extensions = [ ".py" ".pyi" ];
          };

          ty = {
            command = [ "ty" "server" ];
            extensions = [ ".py" ".pyi" ];
          };

          tofu-ls = {
            command = [ "tofu-ls" "serve" ];
            extensions = [ ".tf" ".tfvars" ];
          };

          marksman = {
            command = [ "marksman" "server" ];
            extensions = [ ".md" ".markdown" ];
          };

          taplo = {
            command = [ "taplo" "lsp" "stdio" ];
            extensions = [ ".toml" ];
          };

          json-lsp = {
            command = [ "vscode-json-language-server" "--stdio" ];
            extensions = [ ".json" ".jsonc" ];
          };
        };
        watcher.ignore = [
          "**/.git/**"
          "**/.ansible/**"
          "**/node_modules/**"
          "**/.cache/**"
          "**/dist/**"
        ];
        permission.bash = {
          "rm" = "ask";
          "rm *" = "ask";
          "git reset --hard*" = "deny";
          "git checkout --*" = "deny";
          "git clean -fd*" = "deny";
          "git clean -fdx*" = "deny";
          "git push -f*" = "deny";
          "git push --force*" = "deny";
          "git push --force-with-lease*" = "deny";
        };
        mcp = {
          context7 = {
            type = "remote";
            url = "https://mcp.context7.com/mcp";
            enabled = true;
          };
          gh_grep = {
            type = "remote";
            url = "https://mcp.grep.app";
            enabled = true;
          };
          obsidian = {
            type = "local";
            command = [ "uvx" "--from" "mcp-obsidian==0.2.2" "--with" "mcp==1.12.4" "mcp-obsidian" ];
            environment = {
              OBSIDIAN_API_KEY = "{env:OBSIDIAN_API_KEY}";
              OBSIDIAN_HOST = "{env:OBSIDIAN_HOST}";
              OBSIDIAN_PORT = "{env:OBSIDIAN_PORT}";
            };
            enabled = true;
          };
          playwright = {
            type = "local";
            command = [ "npx" "@playwright/mcp@latest" ];
            enabled = false;
          };
          zotero = {
            type = "local";
            command = [ "uvx" "zotero-mcp" ];
            environment = {
              ZOTERO_LOCAL = "true";
            };
            enabled = false;
          };
        };
      };
      tui = {
        "$schema" = "https://opencode.ai/tui.json";
        theme = "catppuccin-macchiato";
        plugin = [
          "@slkiser/opencode-quota"
        ];
      };
      agents = lib.mapAttrs' (filename: _:
        lib.nameValuePair (lib.removeSuffix ".md" filename) (./config/agents + "/${filename}")
      ) (lib.filterAttrs (n: v: v == "regular") (builtins.readDir ./config/agents));
      commands = lib.mapAttrs' (filename: _:
        lib.nameValuePair (lib.removeSuffix ".md" filename) (./config/commands + "/${filename}")
      ) (lib.filterAttrs (n: v: v == "regular") (builtins.readDir ./config/commands));
      skills = lib.mapAttrs' (dirname: _:
        lib.nameValuePair dirname (./config/skills + "/${dirname}")
      ) (lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./config/skills));
    };

    catppuccin.opencode.enable = true;

    home.file.".config/opencode/dcp.jsonc".text = builtins.toJSON {
      "$schema" = "https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/dcp.schema.json";
      enabled = true;
      debug = false;
      pruneNotification = "minimal";
      pruneNotificationType = "toast";
      experimental.allowSubAgents = true;
      compress = {
        permission = "allow";
        nudgeForce = "soft";
        nudgeFrequency = 5;
        minContextLimit = 30000;
        maxContextLimit = 75000;
      };
      strategies = {
        deduplication.enabled = true;
        purgeErrors = {
          enabled = true;
          turns = 4;
        };
      };
    };
    home.file.".config/opencode/plugins/rtk.ts".source = pkgs.rtk.src + "/hooks/opencode/rtk.ts";

    shell.secretRefs = {
      OBSIDIAN_API_KEY = "op://Private/Obsidian.md/api key";
    };

    home.sessionVariables = {
      OBSIDIAN_HOST = "127.0.0.1";
      OBSIDIAN_PORT = "27124";
    };

    programs.zsh.shellAliases = {
      oc = "opencode";
      os = "opencode-sessionizer";
    };
  };
}
