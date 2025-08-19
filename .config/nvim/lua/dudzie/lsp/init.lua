-- This is the main entry point for the entire LSP configuration.

-- 1. UI & UX CONFIGURATION
-- Configure diagnostics appearance
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
-- Start, Stop, Restart, Log commands {{{
vim.api.nvim_create_user_command("LspStart", function()
    vim.cmd.e()
end, { desc = "Starts LSP clients in the current buffer" })

vim.api.nvim_create_user_command("LspStop", function(opts)
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if opts.args == "" or opts.args == client.name then
            client:stop(true)
            vim.notify(client.name .. ": stopped")
        end
    end
end, {
    desc = "Stop all LSP clients or a specific client attached to the current buffer.",
    nargs = "?",
    complete = function(_, _, _)
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local client_names = {}
        for _, client in ipairs(clients) do
            table.insert(client_names, client.name)
        end
        return client_names
    end,
})

vim.api.nvim_create_user_command("LspRestart", function()
    local detach_clients = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        client:stop(true)
        if vim.tbl_count(client.attached_buffers) > 0 then
            detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
        end
    end
    local timer = vim.uv.new_timer()
    if not timer then
        return vim.notify("Servers are stopped but havent been restarted")
    end
    timer:start(
        100,
        50,
        vim.schedule_wrap(function()
            for name, client in pairs(detach_clients) do
                local client_id = vim.lsp.start(client[1].config, { attach = false })
                if client_id then
                    for _, buf in ipairs(client[2]) do
                        vim.lsp.buf_attach_client(buf, client_id)
                    end
                    vim.notify(name .. ": restarted")
                end
                detach_clients[name] = nil
            end
            if next(detach_clients) == nil and not timer:is_closing() then
                timer:close()
            end
        end)
    )
end, {
    desc = "Restart all the language client(s) attached to the current buffer",
})

vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.vsplit(vim.lsp.log.get_filename())
end, {
    desc = "Get all the lsp logs",
})

vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("silent checkhealth vim.lsp")
end, {
    desc = "Get all the information about all LSP attached",
})

-- 2. GLOBAL LSP DEFAULTS
-- Set shared capabilities and on_attach for ALL servers using the '*' wildcard.
vim.lsp.config["*"] = {
    on_attach = require("dudzie.lsp.utils.on_attach"),
    capabilities = require("dudzie.lsp.utils.capabilities"),
}

-- 3. ENABLE AUTO-STARTING SERVERS
vim.lsp.enable({ "ruff", "lua_ls" })

-- 4. HANDLE MANUAL-START PYTHON SERVER
-- This gives us fine-grained control over venv activation and root detection.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(event)
    -- ... (venv setup logic) ...

    local root = vim.fs.root(event.buf, { "pyproject.toml", ".git", "setup.cfg" }) or vim.uv.cwd()

    -- DEFINE the base config directly here instead of requiring it.
    local basedpyright_base_config = {
      name = "basedpyright",
      cmd = { "basedpyright-langserver", "--stdio" },
      filetypes = { "python" },
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "strict",
            inlayHints = {
              variableTypes = true,
              functionReturnTypes = true,
              callArgumentNames = true,
            },
          },
        },
      },
    }

    local final_config = vim.tbl_deep_extend(
      "force",
      basedpyright_base_config,
      { root_dir = root }
    )

    local client_id = vim.lsp.start(final_config, { attach = false, bufnr = event.buf })
    if client_id then
      vim.lsp.buf_attach_client(event.buf, client_id)
    end
  end,
})
