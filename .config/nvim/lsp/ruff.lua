return {
    -- Command to start the ruff language server.
    cmd = { "ruff", "server" },

    -- Filetypes that ruff-lsp should attach to.
    filetypes = { "python" },

    -- Markers to identify the root of a Python project for ruff.
    root_markers = { "ruff.toml", "pyproject.toml", ".git", "setup.cfg" },

    -- Server-specific settings for ruff-lsp.
    init_options = {
        settings = {
            -- General arguments for the `ruff` CLI, not specific subcommands.
            -- Usually empty if ruff.toml is project-local or global defaults are fine.
            args = {},

            -- Code action settings
            codeAction = {
                disableRuleComment = {
                    enable = true -- Keep this true to easily add # noqa comments
                },
                fixViolation = {
                    enable = true -- Keep this true to allow auto-fixing individual violations
                }
            },

            -- Linting settings
            lint = {
                enable = true,
                preview = true,
            },

            -- Formatting settings
            format = {
                preview = true,
            }
        }
    },

    on_attach = function(client, bufnr)
        vim.notify("Ruff LSP attached to buffer " .. bufnr)

        -- Example: Keymap for Ruff's "Organize Imports"
        vim.keymap.set("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports.ruff" }, diagnostics = {} },
                apply = true,
                filter = function(action) return action.title and string.match(action.title, "Ruff: Organize imports") end,
            })
        end, { buffer = bufnr, noremap = true, silent = true, desc = "LSP: Ruff Organize Imports" })

        -- Example: Keymap for Ruff's "Fix All"
        vim.keymap.set("n", "<leader>fix", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.fixAll.ruff" }, diagnostics = vim.diagnostic.get(bufnr) },
                apply = true,
                filter = function(action)
                    return action.title and
                        string.match(action.title, "Ruff: Fix all auto-fixable problems")
                end,
            })
        end, { buffer = bufnr, noremap = true, silent = true, desc = "LSP: Ruff Fix All" })
    end,
}
