" PLUGINS
call plug#begin('$HOME/.config/nvim/plugged')

" Coding Parsing and LSP Plugins
Plug 'neovim/nvim-lspconfig' "LSP Configuration
Plug 'sbdchd/neoformat' "Code Formatter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}      "Better autocomplete
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}  "Autocomplete tools
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'} "Snippets for use with autocomplete

" Directories, searching and files
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'} "Better navigation
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } "Fuzzy Finder

" Appearance plugins
Plug 'sainnhe/gruvbox-material' 
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' "LSP Warnings and errors in virtual lines
Plug 'lukas-reineke/indent-blankline.nvim' "Indents are now visible

call plug#end()
