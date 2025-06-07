return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        branch = "main",
        config = function()

            local ensureInstalled = {} -- (list of your parsers)
            local alreadyInstalled = require("nvim-treesitter.config").get_installed()
            local parsersToInstall = vim.iter(ensureInstalled)
                :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
                :totable()
            require("nvim-treesitter").install(parsersToInstall)

            -- Autocommand for Treesitter features (Highlighting, Indent, etc.)
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("MyTreesitterFeatures", { clear = true }),
                desc = "Enable Treesitter features for supported filetypes",
                callback = function(ctx)
                    local buf = ctx.buf
                    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

                    -- 1. Highlighting
                    local max_filesize = 1000 * 1024
                    local file_name = vim.api.nvim_buf_get_name(buf)
                    local disable_highlight = false

                    if file_name and file_name ~= "" then
                        local ok_stat, stats = pcall(vim.loop.fs_stat, file_name)
                        if ok_stat and stats and stats.size > max_filesize then
                            disable_highlight = true
                        end
                    end

                    if not disable_highlight then
                        pcall(vim.treesitter.start, buf, ft)
                    else
                        vim.notify("Treesitter highlight disabled for large file: " .. ft, vim.log.levels.INFO)
                    end

                end,
            })
        end,
    },
}
