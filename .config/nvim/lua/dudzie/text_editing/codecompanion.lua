return {
  "olimorris/codecompanion.nvim",
  opts = {
      chat = {
        adapter = "copilot",
        auto_scroll = false,
        intro_message = "Let's figure it out! Press ? for options.",
      },
      ui = {
        theme = "dark", -- Set the theme for the UI
        border = "rounded", -- Use rounded borders for UI elements
      },
      keymaps = {
        open_chat = "<leader>cc", -- Keymap to open the chat
      },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
