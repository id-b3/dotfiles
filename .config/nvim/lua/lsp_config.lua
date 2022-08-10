local lsp = require('lspconfig')

local custom_attach = function()
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

lsp.pylsp.setup{on_attach=custom_attach}
