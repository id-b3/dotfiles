return {
	"olimorris/codecompanion.nvim",
	keys = {
		{
			"<leader>cp",
			"<cmd>CodeCompanion /pydoc<CR>",
			mode = "v",
			desc = "CodeCompanion: Generate Python Docstrings",
		},
		{
			"<leader>cl",
			function()
				require("codecompanion").chat("local_llm")
			end,
			desc = "CodeCompanion: Chat with local LLM",
		},
		{
			"<leader>cc",
			function()
				require("codecompanion").chat("copilot")
			end,
			desc = "CodeCompanion: Chat with Copilot",
		},
	},
	opts = {
		adapters = {
			http = {
				-- Custom local server adapter
				local_llm = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "http://ashdevslt102:4000/v1",
							api_key = "sk-wtt7V92p3AxHd8y0CLo-Bw",
							chat_url = "/chat/completions",
						},
						schema = {
							model = {
								default = "Qwen3.6-A3B", -- Default to the non-FIM model for chat
								choices = {
									"Qwen3.6-A3B",
									"Qwen2.5-Coder-7B",
								},
							},
						},
						headers = {
							["Content-Type"] = "application/json",
							["Authorization"] = "Bearer ${api_key}",
						},
					})
				end,
			},
		},
		interactions = {
			chat = {
				adapter = "local_llm", -- Use local LLM for chat
			},
			inline = {
				adapter = "copilot", -- Use Copilot for inline autocomplete
			},
		},
		chat = {
			auto_scroll = true,
			intro_message = "Let's figure it out! Press ? for options.",
		},
		prompt_library = {
			markdown = {
				dirs = {
					vim.fn.stdpath("config") .. "/lua/dudzie/text_editing/prompts",
				},
			},
		},
		extensions = {
			history = {
				enabled = true,
				opts = {
					keymap = "gh",
					auto_generate_title = true,
					continue_last_chat = true,
					delete_on_clearing_chat = true,
					picker = "telescope",
					enable_logging = false,
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				},
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/codecompanion-history.nvim",
	},
}
