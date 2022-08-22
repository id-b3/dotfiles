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

nnoremap <S-Up> :m-2<CR>==
nnoremap <S-Down> :m+<CR>==
inoremap <S-Up> <Esc>:m-2<CR>==gi
inoremap <S-Down> <Esc>:m+<CR>==gi
vnoremap <S-Up> :'<,'>m-2<CR>==gv
vnoremap <S-Down> :'<,'>m'>+<CR>==gv

" PLUGINS
call plug#begin('$HOME/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig' "LSP Configuration
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'} "Better navigation
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}      "Better autocomplete
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}  "Autocomplete tools
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'} "Snippets for use with autocomplete
Plug 'tpope/vim-fugitive' "Git integration
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Better syntax and scope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'} "Fuzzy Finder
Plug 'mfussengger/nvim-dap' "Debugging tool
Plug 'rcarriga/nvim-dap-ui' "Debugging UI

" Appearance plugins
Plug 'ellisonleao/gruvbox.nvim' "Gruvbox coding theme
Plug 'EdenEast/nightfox.nvim' "Nightfox coding theme
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' "LSP Warnings and errors in virtual lines
Plug 'lukas-reineke/indent-blankline.nvim' "Indents are now visible

call plug#end()

" Setting up LUAs
lua require('lua_config')

nnoremap <leader>v <cmd>CHADopen<cr>
" nnoremap <leader>c <cmd>COQnow<cr>

" Setting up folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
autocmd BufReadPost,FileReadPost * normal zR

set background=dark
colorscheme terafox
