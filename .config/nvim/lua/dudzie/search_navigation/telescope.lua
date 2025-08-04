return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = { ".git/", "miniconda3/", ".cache", "%.o", "%.a", "%.out", "%.class", "%.pdf", "%.mkv", "%.jpg", "%.png", "%.mp4", "%.opsf", "%.mhd", "%.zip", "__pycache__", ".npy", ".nrrd", ".nii.gz", ".nii" },
            },
        })
    end,
    keys = {
        { '<leader>sf', function() require('telescope.builtin').find_files() end,                                      desc = "[S]earch [F]iles" },
        { '<leader>sg', function() require('telescope.builtin').git_files() end,                                       desc = "[S]earch [G]it" },
        { '<leader>st', function() require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") }) end, desc = "[S]earch [T]ext" },
    }
}
