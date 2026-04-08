return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap",
    },
    config = function()
        local dapui = require("dapui")

        -- 1. SETUP: Your specific layout configuration
        dapui.setup({
            layouts = {
                {
                    elements = {
                        "scopes",
                        "breakpoints",
                        "stacks",
                        "watches",
                    },
                    size = 0.2,
                    position = "left",
                },
                {
                    elements = {
                        "repl",
                        "console",
                    },
                    size = 0.3,
                    position = "bottom",
                },
                {
                    elements = {
                        -- Console takes 70% of the vertical space in this sidebar
                        { id = "console", size = 0.70 },
                        -- REPL takes 30% of the vertical space
                        { id = "repl", size = 0.30 },
                    },
                    size = 0.30, -- 30% of screen width
                    position = "left",
                },
            },
            floating = {
                max_height = 0.5,
                max_width = 0.8, -- Floats will be 90% of screen size
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            render = {
                max_type_length = 120,
            },
        })
    end,
    keys = {
        -- 1. Toggle DAP UI (Sidebar/Tray)
        { mode = "n", "<F1>",       function() require("dapui").toggle({ layout = 1 }) end,                                   desc = "Toggle DAP UI" },
        { mode = "n", "<leader>db", function() require("dapui").toggle({ layout = 2 }) end, desc = "Toggle [D]AP [B]ottom Tray" },
        { mode = "n", "<leader>dp", function() require("dapui").toggle({ layout = 3 }) end, desc = "Toggle [D]AP [B]ottom Tray" },
        -- 2. Reset DAP UI Layout (Requested)
        { mode = "n", "<leader>dr", function() require("dapui").open({ reset = true }) end,                     desc = "[D]AP UI [R]eset Layout" },
        -- 3. Floating Console / Output (Requested)
        { mode = "n", "<leader>dc", function() require("dapui").float_element("console", { enter = true }) end, desc = "[D]AP floating [C]onsole" },
        -- 4. Floating Scopes
        { mode = "n", "<leader>ds", function() require("dapui").float_element("scopes", { enter = true }) end,  desc = "[D]AP floating [S]copes" },
        -- 5. Floating REPL Toggle (Requested - Improved Logic)
        {
            mode = "n",
            "<leader>dt",
            function()
                local dapui = require("dapui")
                -- Check if the float element for repl is currently open
                -- There isn't a direct "is_open" for floats, so we usually just call float_element.
                -- However, calling it twice usually jumps to it rather than closing it.
                -- To get true toggle behavior on a float, we can use the eval window trick or just simple float invocation.
                dapui.float_element("repl", { width = 100, height = 20, enter = true, position = "center" })
            end,
            desc = "[D]AP floating [R]EPL",
        },
        -- 6. Eval Word/Selection (Crucial for workflow)
        { mode = { "n", "v" }, "<leader>de", function() require("dapui").eval() end, desc = "[D]AP [E]valuate Expression" },
    }
}
