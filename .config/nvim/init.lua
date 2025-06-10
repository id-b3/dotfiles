-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup Lazy.nvim with all plugins
require("lazy").setup({
    spec = {
        { import = "dudzie.debugging" },
        { import = "dudzie.version_control" },
        { import = "dudzie.search_navigation" },
        { import = "dudzie.text_editing" },
        { import = "dudzie.misc" },
        { import = "dudzie.appearance" },
        { import = "dudzie.lsp.plugins" },
        -- { import = "dudzie"},
    },
    install = { colorscheme = { "gruvbox-material" } },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- Load core settings and keymaps
require("dudzie.lsp.init")
require("dudzie.set.keymaps")
require("dudzie.set.set")
