require('lsp_config')
require('lsp_lines').setup()
vim.diagnostic.config({
    virtual_text = false,
})

require('nvim-treesitter.configs').setup {
    ensure_installed = {"python", "bash"},
    auto_install = true,
    folding = {enable=true},
    indentation = {enable=true}

}

vim.opt.list = true
vim.opt.listchars:append "eol:↴"
require('indent_blankline').setup({
    show_end_of_line = true,
})

require('nightfox').setup({})
