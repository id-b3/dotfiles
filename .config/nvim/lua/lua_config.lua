require('lsp_config')
require('lsp_lines').setup()
vim.diagnostic.config({
    virtual_text = false,
})

vim.opt.list = true
vim.opt.listchars:append "eol:↴"
require('indent_blankline').setup({
    show_end_of_line = true,
})

-- Treesitter
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        disable = {}
    },
    indent = {
        enable = true,
        disable = {}
    },
    ensure_installed = {
        "python",
        "bash",
        "lua",
        "vim"
    }
})
