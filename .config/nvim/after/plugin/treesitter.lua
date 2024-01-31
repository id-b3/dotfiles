-- Treesitter
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        disable = { "txt" }
    },
    indent = {
        enable = true,
        disable = {}
    },
    ensure_installed = {
        "python",
        "bash",
        "lua",
        "vim",
        "vimdoc"
    }
})

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldlevel = 9
