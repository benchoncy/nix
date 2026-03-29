-- Neovim cmp a completion engine plugin
-- Purpose: Provides autocompletion.

local policy = require("config.ai_policy").load()
local dependencies = {
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-emoji",
  "hrsh7th/cmp-cmdline",
  "onsails/lspkind-nvim",
}

local sources = {
  { name = "nvim_lsp", priority = 100 },
  { name = "buffer", priority = 10 },
  { name = "emoji", group_index = 5, keyword_length = 2 },
  { name = "path", group_index = 6 },
  per_filetype = {
    codecompanion = { "codecompanion" },
  },
}

local symbol_map = {}

if policy.nvim.enable and policy.providers.supermaven.enable then
  table.insert(dependencies, "supermaven-inc/supermaven-nvim")
  table.insert(sources, 1, { name = "supermaven", priority = 150, max_item_count = 3 })
  symbol_map.Supermaven = ""
end

if policy.nvim.enable and policy.providers.githubCopilot.enable then
  table.insert(dependencies, "zbirenbaum/copilot-cmp")
  table.insert(sources, 1, { name = "copilot", priority = 150, max_item_count = 3 })
  symbol_map.Copilot = ""
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = dependencies,
  config = function()
    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local lspkind = require("lspkind")

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = sources,
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      snippet = {},
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = {
            menu = 50,
            abbr = 50,
          },
          ellipsis_char = "...",
          show_labelDetails = true,
          before = function(_, vim_item)
            return vim_item
          end,
          symbol_map = symbol_map,
        }),
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
  end,
}
