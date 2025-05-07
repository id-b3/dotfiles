return {
    "mfussenegger/nvim-dap-python",
    dependencies = {"mfussenegger/nvim-dap"},
    ft = "python",
    lazy = true,
    config = function ()
        require('dap-python').setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
    end,
    keys = {
        {mode = "n", "<leader>duc", function() require('dap-python').test_class() end, silent = true, noremap = true, desc = "[D]AP [U]nittest [C]lass"},
        {mode = "n", "<leader>dum", function() require('dap-python').test_method() end, silent = true, noremap = true, desc = "[D]AP [U]nittest [M]ethod"},
        {mode = "v", "<leader>dus", function() require('dap-python').debug_selection() end, silent = true, noremap = true, desc = "[D]AP [U]nittest [S]election"},
    }
}
