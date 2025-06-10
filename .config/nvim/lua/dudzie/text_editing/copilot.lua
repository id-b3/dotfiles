return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
    dependencies = {
    {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup({
        })
      end,
    },
},
  opts = {
    panel = {
      enabled = false,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
      layout = {
        position = "bottom",
        ratio = 0.4,
      },
    },

    -- Suggestion Configuration
    -- Set enabled = true if you want to use Copilot's native ghost text.
    suggestion = {
      enabled = false,
      auto_trigger = false, -- True to get suggestions automatically without manual trigger
      hide_during_completion = true,
      debounce = 75,
      trigger_on_accept = true,
      keymap = {
        accept = "<M-l>",       -- Alt-l (Meta-l)
        accept_word = false,    -- Or a key like <M-Right>
        accept_line = false,    -- Or a key like <M-Enter>
        next = "<M-]>",         -- Alt-]
        prev = "<M-[>",         -- Alt-[
        dismiss = "<C-]>",      -- Ctrl-]
      },
    },

    -- Enable for specific filetypes and disable for all others.
    filetypes = {
      python = true,
      sh = true, -- For bash scripts
      lua = true,
      -- Disables copilot for all other filetypes not explicitly set to true
      ["*"] = false,

    },

  },
}
