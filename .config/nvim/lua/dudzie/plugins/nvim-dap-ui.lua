return {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {"mfussenegger/nvim-dap", "folke/neodev.nvim"},
    config = function ()
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup() -- Setup DAP UI
        require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true },
        }) -- Setup neodev with library including nvim-dap-ui.
    end,

}
