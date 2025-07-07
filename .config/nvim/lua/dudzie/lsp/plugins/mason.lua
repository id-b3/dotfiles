return {
    -- Mason package manager
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                "pyright",
                "ruff",
                "lua-language-server",
                "clangd",
                "clang-format",
            },
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    }
}
