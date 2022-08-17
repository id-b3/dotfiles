local lsp = require('lspconfig')
local coq = require('coq')

local custom_attach = function()
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    coq.lsp_ensure_capabilities()
end

lsp.pylsp.setup{on_attach=custom_attach}
