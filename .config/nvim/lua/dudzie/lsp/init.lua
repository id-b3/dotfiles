return {
    -- Mason package manager
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = require("dudzie.lsp.func.utils").mason_opts,
        config = function(_, opts)
            require("mason").setup(opts)
            require("dudzie.lsp.func.utils").ensure_installed()
        end,
    },

    -- Core LSP support
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            -- Configure diagnostics
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
            })

            -- Define diagnostic signs
            local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- Load your existing setup
            require("dudzie.lsp.func.keymaps").setup()
            require("dudzie.lsp.func.servers").setup()
        end
    },

    -- Formatting and linting via none-ls
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("dudzie.lsp.func.null-ls").setup()
        end,
    },

    -- LSP Lines for inline diagnostics
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        enabled = true,
        config = function()
            require("lsp_lines").setup()

            -- Toggle between lsp_lines and virtual text with keymap
            vim.keymap.set("n", "<Leader>lt", function()
                local new_value = not vim.diagnostic.config().virtual_text
                vim.diagnostic.config({
                    virtual_text = new_value,
                    virtual_lines = not new_value,
                })
            end, { desc = "Toggle LSP lines/virtual text" })

            -- Initialize with virtual lines enabled and virtual text disabled
            vim.diagnostic.config({
                virtual_text = false,
                virtual_lines = true,
            })
        end,
    }
}

