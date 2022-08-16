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
