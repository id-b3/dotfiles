syntax on					"syntax highlighting
filetype plugin indent on			"file type detection
set number
set relativenumber
"set path+=** improves searching
set noswapfile
set wildmenu					"autocomplete
set backspace=indent,eol,start			"proper backspace functionality
set undodir=~/.cache/nvim/undo			"undo persists after exiting
set undofile
set incsearch					"display search while completing typing
set smartindent
set ic
"set colorcolumn=80				"When line reaches 80 characters, change colour (pep8)
set expandtab					"expand tab to spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set showmatch
set hlsearch incsearch				"highlight all previous searches with incsearch

nnoremap <C-l> :nohl<CR><C-l>:echo "Search Cleared"<CR>

" PLUGINS
call plug#begin('$HOME/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig' "LSP Configuration
Plug 'numToStr/Comment.nvim' "Commenting tool
Plug 'jiangmiao/auto-pairs'     "Auto-close brackets and scopes
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'} "Better navigation
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}      "Better autocomplete
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}  "Autocomplete tools
Plug 'tpope/vim-fugitive' "Git integration
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Better syntax and scope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'} "Fuzzy Finder
Plug 'github/copilot.vim'

call plug#end()

" Setting up LSP
lua require('lua_config')

nnoremap <leader>v <cmd>CHADopen<cr>

let g:coq_settings = { 'auto_start': 'shut-up' }
