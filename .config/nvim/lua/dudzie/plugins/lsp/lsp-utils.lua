local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

M.setup = function()
    local bufopts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<cr>", bufopts)
	vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<cr>", bufopts)
	vim.keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<cr>", bufopts)
	vim.keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<cr>", bufopts)
	vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
	 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	 end, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
end

M.on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

return M
