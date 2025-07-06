return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        -- Custom Copilot component
        local copilot_component = {
            function()
                local icon = ""
                local status = ""

                -- Check if copilot is loaded and get its status
                local ok, copilot_api = pcall(require, "copilot.api")
                if ok then
                    local copilot_status = copilot_api.status.data.status
                    if copilot_status == "InProgress" then
                        status = "pending"
                    elseif copilot_status == "Warning" then
                        status = "error"
                    else
                        status = "ok"
                    end
                else
                    -- Check if copilot client is attached
                    local clients = vim.lsp.get_active_clients({ name = "copilot", bufnr = 0 })
                    if #clients > 0 then
                        status = "ok"
                    else
                        return ""  -- Don't show anything if copilot isn't active
                    end
                end

                return icon .. status
            end,
            color = function()
                local colors = {
                    ok = { fg = "#6CC644" },      -- GitHub green
                    pending = { fg = "#FFA500" },  -- Orange
                    error = { fg = "#FF0000" },    -- Red
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

        require('lualine').setup({
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {
                    copilot_component,  -- Add Copilot status here
                    'encoding', 
                    'fileformat', 
                    'filetype'
                },
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
        })
    end,
}

