" PLUGINS
call plug#begin('$HOME/.config/nvim/plugged')

" General VIM Improvements
Plug 'mbbill/undotree' "Control over the NVIM undo tree
Plug 'tpope/vim-fugitive' "Best Git plugin

" Coding Parsing and LSP Plugins
Plug 'neovim/nvim-lspconfig' "LSP Configuration
Plug 'williamboman/mason.nvim' 
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'sbdchd/neoformat' "Code Formatter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}      "Better autocomplete
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}  "Autocomplete tools
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'} "Snippets for use with autocomplete
Plug 'numToStr/Comment.nvim' "Easy line/block commenting

" Directories, searching and files
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'} "Better navigation
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } "Fuzzy Finder
Plug 'ggandor/leap.nvim'     "Navigation

" Appearance plugins
Plug 'sainnhe/gruvbox-material' 
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' "LSP Warnings and errors in virtual lines
Plug 'lukas-reineke/indent-blankline.nvim' "Indents are now visible

" Generative AI
Plug 'MunifTanjim/nui.nvim'
Plug 'dpayne/CodeGPT.nvim'
Plug 'jackMort/ChatGPT.nvim'

call plug#end()
