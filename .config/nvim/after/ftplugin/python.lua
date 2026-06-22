vim.bo.keywordprg = ""
-- Create an async function to fetch Ruff workspace files
local function ruff_workspace_files()
	vim.notify("Scanning workspace with Ruff...", vim.log.levels.INFO, { title = "Ruff Workspace" })

	-- Run the Ruff CLI asynchronously
	vim.system({ "ruff", "check", "--output-format=json", "." }, { text = true }, function(out)
		if out.code ~= 0 and out.code ~= 1 then
			vim.schedule(function()
				vim.notify(
					"Ruff failed to execute (exit code "
						.. tostring(out.code)
						.. "):\n"
						.. (out.stderr or "Command not found."),
					vim.log.levels.ERROR,
					{ title = "Ruff Workspace" }
				)
			end)
			return
		end

		local ok, results = pcall(vim.json.decode, out.stdout)
		if not ok then
			if out.stdout and out.stdout ~= "" then
				vim.schedule(function()
					vim.notify("Failed to parse Ruff JSON output.", vim.log.levels.ERROR, { title = "Ruff Workspace" })
				end)
			end
			return
		end

		-- Aggregate issues by file
		local file_summary = {}
		local total_issues = 0

		for _, err in ipairs(results or {}) do
			local fname = err.filename
			if not file_summary[fname] then
				file_summary[fname] = {
					count = 0,
					-- Save the location of the *first* issue found so jumping takes you right to it
					lnum = err.location.row,
					col = err.location.column,
				}
			end
			file_summary[fname].count = file_summary[fname].count + 1
			total_issues = total_issues + 1
		end

		-- Convert the aggregated summary into Neovim Quickfix items
		local qf_items = {}
		local total_files = 0
		for fname, data in pairs(file_summary) do
			total_files = total_files + 1
			table.insert(qf_items, {
				filename = fname,
				lnum = data.lnum,
				col = data.col,
				text = string.format("Contains %d Ruff issue%s", data.count, data.count > 1 and "s" or ""),
				type = "W", -- Treat as a generic 'Warning' for highlighting purposes
			})
		end

		-- Return to the main thread to update the UI
		vim.schedule(function()
			-- Set the Quickfix list with our aggregated files
			vim.fn.setqflist({}, "r", { title = "Ruff Affected Files", items = qf_items })

			-- Calculate 25% of the current Neovim window width
			local target_width = math.floor(vim.o.columns * 0.25)

			-- Try loading trouble for a richer display
			local has_trouble, trouble_or_err = pcall(require, "trouble")

			if #qf_items > 0 then
				vim.notify(
					string.format("Found %d issues across %d files.", total_issues, total_files),
					vim.log.levels.WARN,
					{ title = "Ruff Workspace" }
				)

				local opened_with_trouble = false

				if has_trouble then
					-- 1. Open Document Diagnostics Pane (Bottom side)
					-- We open this first so it sits in the background.
					-- `buf = 0` tells Trouble to dynamically follow your active main buffer.
					pcall(trouble_or_err.open, {
						mode = "diagnostics",
						filter = {
							buf = 0,
							-- Native Neovim severity filter:
							-- Ignores ty (ERROR = 1), keeps Ruff (WARN = 2)
							severity = vim.diagnostic.severity.WARN,
						},
						win = {
							type = "split",
							position = "bottom",
							size = 10,
						},
					})

					-- 2. Open the Workspace Files Pane (Left side)
					-- We open this second and apply `focus = true` so your cursor
					-- immediately lands here, ready to press `j` and `Enter`
					local success, err = pcall(trouble_or_err.open, {
						mode = "quickfix",
						focus = true,
						win = {
							type = "split",
							position = "left",
							size = target_width,
						},
					})

					if not success then
						vim.notify(
							"Trouble failed to open.\nError: " .. tostring(err),
							vim.log.levels.WARN,
							{ title = "Ruff Workspace" }
						)
					else
						opened_with_trouble = true
					end
				end

				-- Fallback to standard Quickfix if Trouble is missing or crashed
				if not opened_with_trouble then
					vim.cmd("copen")
					-- Move the quickfix window to the far left (H) and resize it
					vim.cmd("wincmd H")
					vim.cmd("vertical resize " .. tostring(target_width))
				end
			else
				vim.notify("Workspace is clean!", vim.log.levels.INFO, { title = "Ruff Workspace" })

				if has_trouble then
					pcall(trouble_or_err.close)
				else
					vim.cmd("cclose")
				end
			end
		end)
	end)
end

-- Create a buffer-local keymap to trigger the workspace file scan
vim.keymap.set("n", "<leader>cR", ruff_workspace_files, {
	buffer = true,
	silent = true,
	desc = "[R]uff affected files (Trouble)",
})
