return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {
                    keys = {
                        { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header (C/C++)" },
                    },
                    root_dir = require("lspconfig.util").root_pattern(
                        ".clangd",
                        ".clang-complete",
                        "compile_commands.json"
                    ),
                    capabilities = {
                        offsetEncoding = { "utf-8", "utf-16" },
                    },
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
            },
            setup = {
                clangd = function(_, opts)
                    local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
                    require("clangd_extensions").setup(vim.tbl_deep_extend("force", {
                        inlay_hints = {
                            inline = vim.fn.has("nvim-0.10") == 1,
                            -- Options other than `highlight` and `priority` only work
                            -- if `inline` is disabled
                            -- Only show inlay hints for the current line
                            only_current_line = false,
                            -- Event which triggers a refresh of the inlay hints.
                            -- You can make this a list of events to maximize responsivity
                            refresh_event = "InsertLeave",
                            -- The following options are passed to the vim.lsp.inlay_hint virtual text options.
                            -- See `:h vim.lsp.inlay_hint()`
                            highlight = "Comment",
                            priority = 100,
                        },
                        ast = {
                            -- These are passed to the neovim markdown renderer.
                            -- See `:h vim.markdown.render()`
                            renderer = {
                                -- Code blocks in markdown files can be configured to be rendered
                                -- in virtual text with a specific format
                                code_block = {
                                    -- The highlight to use for the code block.
                                    -- This can be a string or a function that returns a string.
                                    highlight = "treesitter",
                                    -- The format to use for the code block.
                                    -- This can be a string or a function that returns a string.
                                    -- The first argument is the code block.
                                    -- The second argument is the language of the code block.
                                    format = "```%2$s\n%1$s\n```",
                                },
                            },
                            -- These are passed to the telescope picker.
                            -- See `:h telescope.defaults.pickers`
                            picker = {
                                find_in_buffer = false,
                            },
                        },
                        memory_usage = {
                            -- These are passed to the telescope picker.
                            -- See `:h telescope.defaults.pickers`
                            picker = {
                                find_in_buffer = false,
                            },
                        },
                        type_hierarchy = {
                            -- These are passed to the telescope picker.
                            -- See `:h telescope.defaults.pickers`
                            picker = {
                                find_in_buffer = false,
                            },
                        },
                    }, clangd_ext_opts or {}))
                    return false
                end,
            },
        },
    },
    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        opts = {},
        config = function() end,
    },
}