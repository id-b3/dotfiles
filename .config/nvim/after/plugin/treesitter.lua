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

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 2
