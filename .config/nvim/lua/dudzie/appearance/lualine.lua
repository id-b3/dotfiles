return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- Custom Copilot component
        local copilot_component = {
            function()
                local icon = ""
                -- Check if copilot client is attached
                local clients = vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
                if #clients == 0 then
                    return "" -- Don't show anything if copilot isn't active
                end

                return icon
            end,
            color = function()
                local colors = {
                    ok = { fg = "#6CC644" },      -- GitHub green
                    pending = { fg = "#FFA500" }, -- Orange
                    error = { fg = "#FF0000" },   -- Red
                }

                local ok, copilot_api = pcall(require, "copilot.api")
                if ok then
                    local status = copilot_api.status.data.status
                    if status == "InProgress" then
                        return colors.pending
                    elseif status == "Warning" then
                        return colors.error
                    else
                        return colors.ok
                    end
                end
                return colors.ok
            end,
        }

        local lualine_x = {
            copilot_component, -- Add Copilot status here
            'encoding',
            'fileformat',
            'filetype',
        }

        local ok, spinner = pcall(require, 'dudzie.components.codecompanion_spinner')
        if ok then
            table.insert(lualine_x, 1, spinner)
        end

        require('lualine').setup({
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = lualine_x,
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
        })
    end,
}
