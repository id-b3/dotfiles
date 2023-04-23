return {

-- General VIM Improvements
{ "mbbill/undotree" }, --Control over the NVIM undo tree

{ "sbdchd/neoformat" },--Code Formatter
{ "nvim-treesitter/nvim-treesitter" },
{ "numToStr/Comment.nvim" },--Easy line/block commenting

-- Directories, searching and files
{ "ms-jpq/chadtree", branch = "chad", run = "python3 -m chadtree deps" },
{ "nvim-lua/plenary.nvim"},
{ "nvim-telescope/telescope.nvim"}, --Fuzzy Finder

-- Appearance plugins
{ "sainnhe/gruvbox-material" },
{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" }, --LSP Warnings and errors in virtual lines
{ "nvim-lualine/lualine.nvim" },
{ "kyazdani42/nvim-web-devicons" },

-- Generative AI
{ "MunifTanjim/nui.nvim" },
{ "dpayne/CodeGPT.nvim" },
{ "jackMort/ChatGPT.nvim"}

}
