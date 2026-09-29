-- Treesitter plugin configuration
-- Purpose: Provides syntax highlighting.

return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local languages = {
            'bash',
            'go',
            'lua',
            'luadoc',
            'python',
            'rust',
            'toml',
            'yaml',
            'json',
            'markdown',
            'vim',
            'vimdoc',
        }

        require('nvim-treesitter').setup {}
        require('nvim-treesitter').install(languages)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = languages,
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
