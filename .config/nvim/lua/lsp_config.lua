local coq = require('coq')
local lsp = require('lspconfig')

local custom_attach = function()
    coq.lsp_ensure_capabilities()
end

lsp.pylsp.setup{on_attach=custom_attach}
