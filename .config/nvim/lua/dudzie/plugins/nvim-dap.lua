return {
    "mfussenegger/nvim-dap",
    keys = {
        {"<leader>b", function() require("dap").toggle_breakpoint() end},
    }
}
