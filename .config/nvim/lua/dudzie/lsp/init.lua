vim.lsp.enable({
    "basedpyright",
    "lua_ls",
    "ruff",
})

vim.diagnostic.config({
    virtual_lines = true,
    -- virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})

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
