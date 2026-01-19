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
            prompt_library = {
        ["Python Documentation"] = {
            strategy = "inline",
            description = "Use SphinxAPI style to add or update docstrings.",
            opts = {
                modes = { "v" },
                short_name = "pydoc",
                stop_context_insertion = true,
                is_slash_cmd = true,
            },
            prompts = {
                {
                    role = "system",
                    content = "You are an expert python programmer. You will be provided with a python function, and you will add or update its docstring to follow the SphinxAPI style. Ensure that the docstring is clear, concise, and accurately describes the function's purpose, parameters, and return values. If the function already has a docstring, improve it to adhere to the SphinxAPI style. Stick to the python 3.12+ version style like `int | None`. The parameters should be added with :param x: Desc and followed up with :type x: type. Also add any raises to the docs if needed. If the function is missing typing in some variables or return, add that too. Make sure you apply the correct indentation as the original code snippet.",
                },
                {   role = "user",
                    content = function(context)
                        local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                        return "```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
                    end,
                    opts = {
                        contains_code = true,
                    },
                },
            },
        }
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
