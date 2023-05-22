return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("harpoon").setup({
            global_settings = {
                save_on_toggle = false,
                save_on_change = true,
            },
        })
    end,
    keys = {
        {"<leader>a", function() require("harpoon.mark").add_file() end},
        {"<C-e>", function() require("harpoon.ui").toggle_quick_menu() end},
        {"<C-h>", function() require("harpoon.ui").nav_next() end},
        {"<C-t>", function() require("harpoon.ui").nav_prev() end},
    }
}
