return {
    "Eandrju/cellular-automaton.nvim",
    config = function ()
        require("cellular-automaton").setup()
    end,
    keys = {
        {mode = "n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Shit..."}
    }
}
