return {
  "christoomey/vim-tmux-navigator",
  lazy = false,  -- Essential: load immediately
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
  config = function()
    -- Define mappings with keymap.set (no <C-U> needed)
    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }
    map("n", "<A-Left>",  "<cmd>TmuxNavigateLeft<cr>",  opts)
    map("n", "<A-Down>",  "<cmd>TmuxNavigateDown<cr>",  opts)
    map("n", "<A-Up>",    "<cmd>TmuxNavigateUp<cr>",    opts)
    map("n", "<A-Right>", "<cmd>TmuxNavigateRight<cr>", opts)
  end,
}
