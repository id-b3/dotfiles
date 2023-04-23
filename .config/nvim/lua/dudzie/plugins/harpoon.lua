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
}
