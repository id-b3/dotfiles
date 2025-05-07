local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

-- Config
keymap('n', '<leader><leader>x', '<cmd>source %<CR>', default_opts)

-- Formatting shortcut
keymap('n', '<leader>=', ':Neoformat<CR>', default_opts)
keymap('n', '<C-l>', ':nohl<CR><C-l>:echo "Search Cleared"<CR>', default_opts)

-- Copy/Pasting
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Center focus
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Line Shifting
keymap('n', '<S-Up>', ':m-2<CR>==', default_opts)
keymap('n', '<S-Down>', ':m+<CR>==', default_opts)
keymap('i', '<S-Up>', '<Esc>:m-2<CR>==gi', default_opts)
keymap('i', '<S-Down>', '<Esc>:m+<CR>==gi', default_opts)
keymap('v', '<S-Up>', ":m '<-2<CR>gv=gv", default_opts)
keymap('v', '<S-Down>', ":m '>+1<CR>gv=gv", default_opts)

-- Session Control
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Quick replace
vim.keymap.set("n", "<leader>qr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[Q]uick [R]eplace"})
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true , desc = "Make e[X]ecutable"})
