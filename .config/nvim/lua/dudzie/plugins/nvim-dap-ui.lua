return {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "folke/neodev.nvim"},
    config = function ()
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup() -- Setup DAP UI
        require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true },
        }) -- Setup neodev with library including nvim-dap-ui.

        -- Attach event listeners for DAP
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end

        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end

        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end

        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
    end,

}
