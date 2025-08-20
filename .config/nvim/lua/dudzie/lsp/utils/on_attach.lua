return function(client, bufnr)
    -- 1. SERVER CAPABILITY SETUP
    if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client.server_capabilities.definitionProvider then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    -- 2. KEYMAP SETUP
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = "LSP: " .. desc })
    end

    -- Navigation & Information (Simple, direct mappings)
    map("n", "gD", function() require("dudzie.lsp.utils.definition").get_def() end, "Go to Declaration (Float)")
    map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to Definition (Telescope)")
    map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Go to Implementation (Telescope)")
    map("n", "gr", "<cmd>Telescope lsp_references<cr>", "Show References (Telescope)")
    map("n", "K", function() vim.lsp.buf.hover({ border = "single", max_height = 30, max_width = 120 }) end,
        "Toggle hover")
    map("n", "<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")

    -- Workspace & Document Symbols
    map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols")
    map("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols")

    -- Actions & Refactoring
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map("n", "<leader>lh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })) end,
        "Toggle Inlay Hints")
    map("n", "<leader>ll", vim.lsp.codelens.run, "Run CodeLens Action")

    -- Diagnostics
    map("n", "gl", vim.diagnostic.open_float, "Show Line Diagnostics")
    map("n", "[d", function() vim.diagnostic.goto_prev({ float = true }) end, "Previous Diagnostic")
    map("n", "]d", function() vim.diagnostic.goto_next({ float = true }) end, "Next Diagnostic")
    map("n", "<leader>dq", vim.diagnostic.setloclist, "Diagnostics to Loclist")
    map("n", "<leader>dv", function()
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
    end, "Toggle Diagnostic Virtual Text")

    -- 3. SERVER-SPECIFIC LOGIC
    if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
        map("n", "<leader>oi",
            function() vim.lsp.buf.code_action({ context = { only = { "source.organizeImports.ruff" } }, apply = true }) end,
            "Ruff Organize Imports")
        map("n", "<leader>fix",
            function() vim.lsp.buf.code_action({ context = { only = { "source.fixAll.ruff" } }, apply = true }) end,
            "Ruff Fix All")
    end
    if client.name == "basedpyright" then
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end

    vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO, { title = "LSP" })
end
