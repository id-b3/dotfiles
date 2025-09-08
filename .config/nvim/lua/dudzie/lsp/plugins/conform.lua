return {
    {
        "stevearc/conform.nvim",
        enabled = false,
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format" },
                cpp = { "clang_format" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = false,
            },
        },
    },
}
