return { {"sainnhe/gruvbox-material", priority = 1000 , config = function ()
    vim.o.background = "dark"
    vim.o.gruvbox_material_background = "hard"
    vim.o.gruvbox_material_better_performance = 1
    vim.o.gruvbox_material_enable_bold = 1
    vim.o.gruvbox_material_enable_italics = 1
    vim.o.gruvbox_material_transparent_background = 1
    vim.cmd([[colorscheme gruvbox-material]])
end
}}
