---@type vim.lsp.Config
return {
    cmd = { "texlab" },
    filetypes = { "bib", "plaintex", "tex" },
    root_markers = { ".latexmkrc", "latexmkrc", "texlabroot", ".git" },
    settings = {
        texlab = {
            bibtexFormatter = "texlab",
            chktex = {
                onEdit = true,
                onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 120,
        },
    },
}
