return {
  "olimorris/codecompanion.nvim",
  opts = {
      chat = {
        adapter = "copilot",
        auto_scroll = false,
        intro_message = "Let's figure it out! Press ? for options.",
      },
      actions = {
        -- Example of a custom action palette
        ["Agentic Workflow"] = {
          ["Review for bugs"] = "Review the selected code for potential bugs and suggest fixes.",
          ["Write unit tests"] = "Write unit tests for the selected code.",
          ["Refactor module"] = "Refactor the selected code into a separate, reusable module.",
        },
      },
      extensions = {
        history = {
            enabled = true,
            opts = {
                -- Keymap to open history from chat buffer (default: gh)
                keymap = "gh",
                -- Automatically generate titles for new chats
                auto_generate_title = true,
                ---On exiting and entering neovim, loads the last chat on opening chat
                continue_last_chat = true,
                ---When chat is cleared with `gx` delete the chat from history
                delete_on_clearing_chat = true,
                -- Picker interface ("telescope" or "default")
                picker = "telescope",
                ---Enable detailed logging for history extension
                enable_logging = false,
                ---Directory path to save the chats
                dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            }
        }
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
}
