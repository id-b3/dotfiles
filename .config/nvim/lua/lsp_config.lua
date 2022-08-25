vim.g.coq_settings = { auto_start = true }
local lsp = require('lspconfig')
local coq = require('coq')

local custom_attach = function()
    coq.lsp_ensure_capabilities()
end

lsp.pylsp.setup{on_attach=custom_attach}
