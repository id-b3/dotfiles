return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format", "ruff_fix" },
                cpp = { "clang_format" },
                json = { "prettier" },
                markdown = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 1000,
                lsp_fallback = "never",
            },
            default_format_opts = {
                quiet = true,
            },
        },
    },
}
