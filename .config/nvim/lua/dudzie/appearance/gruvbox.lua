return { {"sainnhe/gruvbox-material", lazy = false, enabled = true, priority = 1000 , config = function ()
    vim.o.background = "dark"
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italics = 1
    vim.g.gruvbox_material_transparent_background = 1
    vim.cmd([[colorscheme gruvbox-material]])
end
}}
