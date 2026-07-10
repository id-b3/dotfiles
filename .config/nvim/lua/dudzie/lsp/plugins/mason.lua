return {
	-- Mason package manager
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"ruff",
				"lua-language-server",
				"clangd",
				"clang-format",
				"ty",
				"tinymist",
				"stylua",
				"prettier",
				"debugpy",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
}
