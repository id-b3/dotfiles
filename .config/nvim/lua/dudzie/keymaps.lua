local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

-- Formatting shortcut
keymap('n', '<leader>=', ':Neoformat<CR>', default_opts)
keymap('n', '<C-l>', ':nohl<CR><C-l>:echo "Search Cleared"<CR>', default_opts)

-- Line Shifting
keymap('n', '<S-Up>', ':m-2<CR>==', default_opts)
keymap('n', '<S-Down>', ':m+<CR>==', default_opts)
keymap('i', '<S-Up>', '<Esc>:m-2<CR>==gi', default_opts)
keymap('i', '<S-Down>', '<Esc>:m+<CR>==gi', default_opts)
keymap('v', '<S-Up>', ":'<,'>m-2<CR>==gv", default_opts)
keymap('v', '<S-Down>', ":'<,'>m+<CR>==gv", default_opts)

-- Plugin Shortcuts
keymap('n', '<leader>v', '<cmd>CHADopen<CR>', default_opts)
keymap('n', '<leader>c', '<cmd>COQnow<CR>', default_opts)
