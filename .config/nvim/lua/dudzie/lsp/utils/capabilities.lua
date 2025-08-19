local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Safely load and merge the capabilities from blink.cmp.
local ok, blink_lsp = pcall(require, "blink_cmp.sources.lsp")
if ok then
    capabilities = vim.tbl_deep_extend("force", capabilities, blink_lsp.capabilities())
end

-- Add custom capabilities like folding support.
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

return capabilities
