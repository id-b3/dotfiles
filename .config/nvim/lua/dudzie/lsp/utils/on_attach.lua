return function(client, bufnr)
    -- On attach, populate diagnostics for the entire workspace for a project-wide view.
    local diag_ok, diag = pcall(require, "dudzie.lsp.utils.workspace_diagnostic")
    if diag_ok then
        diag.populate_workspace_diagnostics(client, bufnr)
    end

    -- Enable omnifunc completion for use with completion engines.
    if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    -- Helper for creating buffer-local keymaps.
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = "LSP: " .. desc })
    end

    -- Keymaps for LSP navigation and information.
    map("n", "gD", function()
        local def_ok, definition = pcall(require, "dudzie.lsp.utils.definition")
        if def_ok then
            definition.get_def()
        else
            vim.lsp.buf.declaration() -- Fallback to default behavior
        end
    end, "Go to Declaration (Float)")
    map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to Definition")
    map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Go to Implementation")
    map("n", "gr", "<cmd>Telescope lsp_references<cr>", "Show References")
    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

    -- Keymaps for actions and refactoring.
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>lh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
    end, "Toggle Inlay Hints")

    -- Keymaps for diagnostics.
    map("n", "gl", vim.diagnostic.open_float, "Show Line Diagnostics")
    map("n", "[d", vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Go to Next Diagnostic")
    map("n", "<leader>dD", function()
        if diag_ok then
            diag.populate_workspace_diagnostics(client, bufnr)
            vim.notify("Workspace diagnostics refreshed.", vim.log.levels.INFO)
        end
    end, "Refresh Workspace Diagnostics")

    -- Server-specific logic.
    if client.name == "ruff" then
        map("n", "<leader>oi", function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports.ruff" } }, apply = true })
        end, "Ruff Organize Imports")
        map("n", "<leader>fix", function()
            vim.lsp.buf.code_action({ context = { only = { "source.fixAll.ruff" } }, apply = true })
        end, "Ruff Fix All")
    end

    if client.name == "basedpyright" then
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end

    vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO, { title = "LSP" })
end
