return {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("noice").setup({
            lsp = {
                progress = {
                enabled = false,
                -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
                -- See the section on formatting for more details on how to customize.
                format = "lsp_progress",
                format_done = "lsp_progress_done",
                throttle = 1000 / 30, -- frequency to update lsp progress message
                view = "mini",
                },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                },
                message = {
                  -- Messages shown by lsp servers
                  enabled = true,
                  view = "notify",
                  opts = {},
                },
                documentation = {
                  view = "hover",
                  opts = {
                    lang = "markdown",
                    replace = true,
                    render = "plain",
                    format = { "{message}" },
                    win_options = { concealcursor = "n", conceallevel = 3 },
                    },
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
        })
        require("notify").setup({
            background_colour = "#000000"
        })
    end,
}
