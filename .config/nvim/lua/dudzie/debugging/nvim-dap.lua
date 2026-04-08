return {
    url = "https://codeberg.org/mfussenegger/nvim-dap.git",
    config = function()
        vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

        -- We link these to standard Neovim colors so they always show up
        vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "DiagnosticError" }) -- Red
        vim.api.nvim_set_hl(0, "DapBreakpointCondition", { link = "DiagnosticWarn" }) -- Yellow
        vim.api.nvim_set_hl(0, "DapLogPoint", { link = "DiagnosticInfo" }) -- Blue
        vim.api.nvim_set_hl(0, "DapStopped", { link = "Constant" }) -- Orange/Green
        vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual" }) -- Highlight the line where execution stopped
    end,
    keys = {
        { mode = "n", "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
        { mode = "n", "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
        { mode = "n", "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
        { mode = "n", "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
        { mode = "n", "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    },
}
