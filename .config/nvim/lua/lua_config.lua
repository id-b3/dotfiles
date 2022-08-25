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

