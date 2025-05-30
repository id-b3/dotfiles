return {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {"mfussenegger/nvim-dap", "folke/neodev.nvim", "nvim-neotest/nvim-nio"},
    config = function ()
        local dapui = require("dapui")

        dapui.setup()
        require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true },
        })
    end,
    keys = {
        {mode = "n", "<F1>", function() require('dapui').toggle() end, desc = "Toggle DAP UI"},
        {mode = "n", "<leader>dfs", function() require('dapui').float_element("scopes", {enter = true}) end, desc = "[D]ap-ui [F]loat [S]copes"},
    }

}
