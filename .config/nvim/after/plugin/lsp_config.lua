local lsp = require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()
local coq = require('coq')
vim.cmd('COQnow')

-- Custom function to map lsp keybindings more easily
local map = function(type, key, value)
    vim.api.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

-- Set keybindings when LSP loads
local custom_attach = function()
    print("LSP started.");
    coq.lsp_ensure_capabilities()

    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    map('n', '<leader>ar', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n', '<leader>ee', '<cmd>lua vim.lsp.buf.show_line_diagnostics()<CR>')
end

lsp.pylsp.setup{on_attach=custom_attach}
