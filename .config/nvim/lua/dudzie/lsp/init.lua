return {
    -- Core LSP support
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
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
            require("dudzie.lsp.func.keymaps").setup()
            require("dudzie.lsp.func.servers").setup()
        end
    },

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
    }
}
