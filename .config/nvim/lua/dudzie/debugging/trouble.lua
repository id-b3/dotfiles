return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    opts = {
    },
    keys = {
        {mode = "n", "[t", function() require("trouble").previous({skip_groups = true, jump = true}) end, silent = true, noremap = true, desc = "Previous [T]rouble point"},
        {mode = "n", "]t", function() require("trouble").next({skip_groups = true, jump = true}) end, silent = true, noremap = true, desc = "Next [T]rouble point"},
        {"<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)", },
    },
}
