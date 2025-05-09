local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local utils = require("dudzie.lsp.func.utils")
    local capabilities = utils.get_capabilities()

    -- Setup mason-lspconfig with automatic_enable
    mason_lspconfig.setup({
        ensure_installed = utils.lsp_servers,
        automatic_enable = true, -- This automatically enables servers installed via Mason
    })

    -- Configure specific servers with vim.lsp.config()
    -- Note: This is the new way to configure LSP servers in Neovim 0.11+
    vim.lsp.config("pyright", {
        on_attach = utils.on_attach,
        capabilities = capabilities,
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = "off"
                }
            }
        }
    })

    vim.lsp.config("lua_ls", {
        on_attach = utils.on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = {"vim"},
                },
            },
        },
    })

    -- For any servers not yet migrated to vim.lsp.config in nvim-lspconfig
    -- You'll need to use the traditional setup method
    -- Example:
    -- if not pcall(vim.lsp.config, "some_server") then
    --     lspconfig.some_server.setup({
    --         on_attach = utils.on_attach,
    --         capabilities = capabilities
    --     })
    -- end
end

return M

