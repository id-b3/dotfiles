return {
    "mfussenegger/nvim-dap",
    keys = {
        {mode = "n", "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Add Breakpoint"},
    }
}
