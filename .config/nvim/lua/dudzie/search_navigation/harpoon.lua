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
        {mode = "n", "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Add file to Harpoon"},
        {"<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Show Harpoon Menu"},
        {"<C-h>", function() require("harpoon.ui").nav_next() end, desc = "Yeet next"},
        {"<C-t>", function() require("harpoon.ui").nav_prev() end, desc = "Yeet prev"},
    }
}
