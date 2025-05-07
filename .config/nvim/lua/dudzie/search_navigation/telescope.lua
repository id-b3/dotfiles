return {
    "telescope.nvim",
    config = function ()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = {".git/", "miniconda3/", ".cache", "%.o", "%.a", "%.out", "%.class", "%.pdf", "%.mkv", "%.jpg", "%.png", "%.mp4", "%.opsf", "%.mhd", "%.zip", "__pycache__", ".npy", ".nrrd", ".nii.gz", ".nii"},
            },
        })
    end,
    keys = {
        {'<leader>sf', require('telescope.builtin').find_files, desc = "[S]earch [F]iles"},
        {'<leader>sg', require('telescope.builtin').find_files, desc = "[S]earch [G]it"},
        {'<leader>st', function() require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ")}); end, desc = "[S]earch [T]ext"},
    }
}
