-- This is the main entry point for the entire LSP configuration.

-- 1. UI & UX CONFIGURATION
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
    },
})

-- Add icons to the completion menu
local icons = {
    Class = " ",
    Method = "ƒ ",
    Function = "󰊕 ",
    Constructor = " ",
    Field = " ",
    Variable = " ",
    Interface = " ",
    Module = "󰏗 ",
    Property = " ",
    Unit = " ",
    Value = " ",
    Enum = " ",
    Keyword = " ",
    Snippet = " ",
    Color = " ",
    File = " ",
    Folder = " ",
}
local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
    if icons[kind] then
        kinds[i] = icons[kind] .. kind
    end
end

-- Add useful user commands for managing LSP
vim.api.nvim_create_user_command("LspStart", function()
    vim.cmd.e() -- Reloads the buffer to trigger LSP attach
end, { desc = "Starts LSP clients in the current buffer" })

vim.api.nvim_create_user_command("LspStop", function(opts)
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if not opts.args or opts.args == "" or opts.args == client.name then
            client:stop(true)
            vim.notify(client.name .. ": stopped")
        end
    end
end, {
    desc = "Stop all or a specific LSP client attached to the current buffer.",
    nargs = "?",
    complete = function()
        return vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))
    end,
})

vim.api.nvim_create_user_command("LspRestart", function()
    vim.notify("Restarting LSP clients...")
    vim.lsp.stop_clients()
    vim.defer_fn(function() vim.cmd.edit() end, 100)
end, { desc = "Restart all language client(s) attached to the current buffer" })

vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.vsplit(vim.lsp.log.get_filename())
end, { desc = "Open the LSP log file" })

vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("silent checkhealth vim.lsp")
end, { desc = "Show LSP health check and information" })

-- 2. GLOBAL LSP DEFAULTS
-- Set shared capabilities and on_attach for ALL servers using the '*' wildcard.
vim.lsp.config["*"] = {
    on_attach = require("dudzie.lsp.utils.on_attach"),
    capabilities = require("dudzie.lsp.utils.capabilities"),
}

-- 3. LOAD & ENABLE SERVERS
-- Enable the servers that should start automatically.
vim.lsp.enable({ "ruff", "lua_ls", "ty" })

-- 4. HANDLE MANUAL-START PYTHON SERVER
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "python",
--     callback = function(event)
--         local venv_ok, venv = pcall(require, "dudzie.lsp.utils.venv")
--         if venv_ok then
--             venv.setup()
--             if venv.cur_env then
--                 vim.notify("Venv: " .. vim.fn.fnamemodify(venv.cur_env, ":t"), vim.log.levels.INFO)
--             end
--         end
--
--         local root = vim.fs.root(event.buf, { "pyproject.toml", ".git", "setup.cfg" }) or vim.uv.cwd()
--
--         local basedpyright_base_config = {
--             name = "basedpyright",
--             cmd = { "basedpyright-langserver", "--stdio" },
--             filetypes = { "python" },
--             settings = {
--                 basedpyright = {
--                     disableOrganizeImports = true,
--                     analysis = {
--                         autoSearchPaths = true,
--                         diagnosticMode = "openFilesOnly",
--                         useLibraryCodeForTypes = true,
--                         typeCheckingMode = "basic",
--                         inlayHints = {
--                             variableTypes = true,
--                             functionReturnTypes = true,
--                             callArgumentNames = true,
--                         },
--                         diagnosticSeverityOverrides = {
--                             reportUnusedImport = "warning",
--                             reportUnusedVariable = "warning",
--                             reportOptionalMemberAccess = false,
--                             reportOptionalSubscript = "warning",
--                             reportOptionalCall = "warning",
--                             reportGeneralTypeIssues = "warning",
--                             reportAttributeAccessIssue = false,
--                             reportPrivateImportUsage = false,
--                             reportArgumentType = false,
--                         },
--                     },
--                 },
--             },
--         }
--
--         local final_config = vim.tbl_deep_extend(
--             "force",
--             basedpyright_base_config,
--             { root_dir = root }
--         )
--
--         local client_id = vim.lsp.start(final_config, { attach = false, bufnr = event.buf })
--         if client_id then
--             vim.lsp.buf_attach_client(event.buf, client_id)
--         end
--     end,
-- })
