return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "codelldb.debug",
                },
                opts = { skip = true },
            },
        },
        views = {
            cmdline_popup = {
                position = {
                    row = 20,
                    col = "50%",
                },
                size = {
                    width = "50%",
                },
            },
            popupmenu = {
                -- relative = "cursor",
                position = {
                    row = "auto",
                    col = "auto",
                },
                size = {
                    width = "auto",
                    height = "auto",
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
            },
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
}
