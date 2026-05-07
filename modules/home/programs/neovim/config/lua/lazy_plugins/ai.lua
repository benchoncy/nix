-- AI code completion and assistive tools configuration.
-- Purpose: Integrates AI-powered features into Neovim for enhanced coding assistance.

-- Note: Using external AI services may have privacy, security and cost implications.

local policy = require("config.ai_policy").load()
local plugins = {}

if policy.nvim.enable and policy.providers.githubCopilot.enable then
  table.insert(plugins, {
    -- Copilot completion source for nvim-cmp
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
  })

  table.insert(plugins, {
    -- GitHub Copilot integration
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        filetypes = {
          -- Enable Copilot for all filetypes
          ["*"] = true,
        },
        -- Disable the default completion handler so that cmp can handle completions
        suggestion = { enabled = false },
        panel = { enabled = false },
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              -- completions for panel
              listCount = 5,
              -- completions for getCompletions
              inlineSuggestCount = 3,
            },
          },
        },
      })
    end,
  })
end

if policy.nvim.enable and policy.providers.supermaven.enable then
  table.insert(plugins, {
    -- Supermaven integration
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        -- disables inline completion for use with cmp
        disable_inline_completion = true,
        -- disables keymaps for use with cmp
        disable_keymaps = true,
      })
    end,
  })
end

return plugins
