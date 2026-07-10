return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"dlyongemallo/diffview-plus.nvim", -- Maintained fork of "sindrets/diffview.nvim".
		"stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
		"nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
	},
	build = function()
		require("gitlab.server").build(true)
	end,
	-- Setting keys here ensures lazy.nvim handles the lazy-loading trigger.
	-- It will automatically load the plugin and call the function on keypress.
	keys = {
		{
			"<leader>gLc",
			function()
				require("gitlab").choose_merge_request()
			end,
			desc = "Choose MR",
		},
		{
			"<leader>gLS",
			function()
				require("gitlab").review()
			end,
			desc = "Start review",
		},
		{
			"<leader>gLs",
			function()
				require("gitlab").summary()
			end,
			desc = "Show MR summary",
		},
		{
			"<leader>gLd",
			function()
				require("gitlab").toggle_discussions()
			end,
			desc = "Toggle discussions",
		},
		{
			"<leader>gLn",
			function()
				require("gitlab").create_note()
			end,
			desc = "Create MR note",
		},

		{
			"<leader>gLA",
			function()
				require("gitlab").approve()
			end,
			desc = "Approve MR",
		},
		{
			"<leader>gLR",
			function()
				require("gitlab").revoke()
			end,
			desc = "Revoke approval",
		},
		{
			"<leader>gLM",
			function()
				require("gitlab").merge()
			end,
			desc = "Merge MR",
		},
		{
			"<leader>gLm",
			function()
				require("gitlab").merge({ auto_merge = true })
			end,
			desc = "Set auto-merge",
		},

		{
			"<leader>gLrr",
			function()
				require("gitlab").rebase()
			end,
			desc = "Rebase MR",
		},
		{
			"<leader>gLrs",
			function()
				require("gitlab").rebase({ skip_ci = true })
			end,
			desc = "Rebase MR and skip CI",
		},
		{
			"<leader>gLrf",
			function()
				require("gitlab").rebase({ force = true })
			end,
			desc = "Force rebase MR",
		},

		{
			"<leader>gLaa",
			function()
				require("gitlab").add_assignee()
			end,
			desc = "Add MR assignee",
		},
		{
			"<leader>gLad",
			function()
				require("gitlab").delete_assignee()
			end,
			desc = "Delete MR assignee",
		},
		{
			"<leader>gLla",
			function()
				require("gitlab").add_label()
			end,
			desc = "Add MR label",
		},
		{
			"<leader>gLld",
			function()
				require("gitlab").delete_label()
			end,
			desc = "Delete MR label",
		},
		{
			"<leader>gLra",
			function()
				require("gitlab").add_reviewer()
			end,
			desc = "Add MR reviewer",
		},
		{
			"<leader>gLrd",
			function()
				require("gitlab").delete_reviewer()
			end,
			desc = "Delete MR reviewer",
		},

		{
			"<leader>gLp",
			function()
				require("gitlab").pipeline()
			end,
			desc = "Show MR pipeline status",
		},
		{
			"<leader>gLu",
			function()
				require("gitlab").copy_mr_url()
			end,
			desc = "Copy MR URL",
		},
		{
			"<leader>gLo",
			function()
				require("gitlab").open_in_browser()
			end,
			desc = "Open MR in browser",
		},
		{
			"<leader>gLD",
			function()
				require("gitlab").toggle_draft_mode()
			end,
			desc = "Toggle MR comment draft mode",
		},
		{
			"<leader>gLP",
			function()
				require("gitlab").publish_all_drafts()
			end,
			desc = "Publish all MR comment drafts",
		},

		-- Missing defaults you might want:
		{
			"<leader>gLC",
			function()
				require("gitlab").create_mr()
			end,
			desc = "Create MR",
		},
		{
			"<leader>gL<C-R>",
			function()
				require("gitlab").reload_review()
			end,
			desc = "Reload MR review",
		},
	},
	config = function()
		require("gitlab").setup({
			keymaps = {
				global = {
					-- Disable default 'gl' global keymaps completely so they don't conflict with diagnostics
					disable_all = true,
				},
			},
		})

		-- Group naming for which-key (v3 syntax)
		local wk = require("which-key")
		wk.add({
			{ "<leader>gL", group = "GitLab" },
		})
	end,
}
