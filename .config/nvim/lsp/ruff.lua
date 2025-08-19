-- Server configuration for ruff.

return {
    cmd = { "ruff", "server", "--preview" },
    filetypes = { "python" },
    root_markers = { "ruff.toml", "pyproject.toml", ".git" },
    init_options = {
        settings = {
            lint = { enable = true, preview = true },
            format = { preview = true },
        },
    },
}
