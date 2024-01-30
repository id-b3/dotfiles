return {
    "mfussenegger/nvim-dap",
    config = function ()
        local dap = require('dap')
        -- Configurations
        vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

    end,
    keys = {
        {mode = "n", "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Add Breakpoint"},
        {mode = "n", "<F6>", function() require("dap").continue() end, desc = "DAP Continue"},
        {mode = "n", "<F8>", function() require("dap").step_over() end, desc = "DAP Step Over"},
        {mode = "n", "<F5>", function() require("dap").step_into() end, desc = "DAP Step Into"},
        {mode = "n", "<F4>", function() require("dap").step_out() end, desc = "DAP Step Out"},
        {mode = "n", "<F12>", function() require("dap.ext.vscode").load_launchjs() end, desc = "Refresh launch.json"},
    },

}
