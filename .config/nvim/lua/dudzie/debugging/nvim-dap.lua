return {
    "mfussenegger/nvim-dap",
    config = function ()
        -- Configurations
        vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
        DAP = require('dap')
    end,
    keys = {
        {mode = "n", "<leader>b", function() DAP.toggle_breakpoint() end, desc = "Add Breakpoint"},
        {mode = "n", "<F6>", function() DAP.continue() end, desc = "DAP Continue"},
        {mode = "n", "<F8>", function() DAP.step_over() end, desc = "DAP Step Over"},
        {mode = "n", "<F5>", function() DAP.step_into() end, desc = "DAP Step Into"},
        {mode = "n", "<F4>", function() DAP.step_out() end, desc = "DAP Step Out"},
        {mode = "n", "<F7>", function() DAP.terminate() end, desc = "DAP Terminate" },
    },

}
