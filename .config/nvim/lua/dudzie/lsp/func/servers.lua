local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local utils = require("dudzie.lsp.func.utils")
    local capabilities = utils.get_capabilities()

    mason_lspconfig.setup({
        ensure_installed = utils.lsp_servers,
    })

    mason_lspconfig.setup_handlers({
        function(server_name)
            lspconfig[server_name].setup({
                on_attach = utils.on_attach,
                capabilities = capabilities
            })
        end,
        ["pyright"] = function()
            lspconfig.pyright.setup({
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
        end,
        ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
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
        end,
    })
end

return M

