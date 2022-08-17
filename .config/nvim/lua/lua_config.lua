require('lsp_config')
require('lsp_lines').setup()
vim.diagnostic.config({
    virtual_text = false,
})

require('nvim-treesitter.configs').setup {
    ensure_installed = {"python", "bash"},
    auto_install = true,
    highlight = {enable=true},
    folding = {enable=true},
    indentation = {enable=true}

}

require('gruvbox').setup(
{
    undercurl = true,
    underline = true,
    bold = true,
    italic = true,
    contrast = "",
}
)
vim.cmd("colorscheme gruvbox")

vim.opt.list = true
vim.opt.listchars:append "eol:↴"
require('indent_blankline').setup({
    show_end_of_line = true,
})
