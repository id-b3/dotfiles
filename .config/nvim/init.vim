syntax on					"syntax highlighting
filetype plugin indent on			"file type detection
set number
set relativenumber
set noswapfile
set wildmenu					"autocomplete
set backspace=indent,eol,start			"proper backspace functionality
set undodir=~/.cache/nvim/undo			"undo persists after exiting
set undofile
set incsearch					"display search while completing typing
set smartindent
set ic
set expandtab					"expand tab to spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set showmatch
set hlsearch incsearch				"highlight all previous searches with incsearch

" Custom Remappings

nnoremap <C-l> :nohl<CR><C-l>:echo "Search Cleared"<CR>
nnoremap <S-Up> :m-2<CR>==      "Move lines up or down using shift
nnoremap <S-Down> :m+<CR>==
inoremap <S-Up> <Esc>:m-2<CR>==gi
inoremap <S-Down> <Esc>:m+<CR>==gi
vnoremap <S-Up> :'<,'>m-2<CR>==gv
vnoremap <S-Down> :'<,'>m'>+<CR>==gv

" Setting up Plugins
source $HOME/.config/nvim/plugins.vim

" Setting up LUAs
lua require('lua_config')

nnoremap <leader>v <cmd>CHADopen<cr>
nnoremap <leader>c <cmd>COQnow<cr>

" Setting up folding
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" autocmd BufReadPost,FileReadPost * normal zR

" Setting up Appearance
set background=dark
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1
colorscheme gruvbox-material
