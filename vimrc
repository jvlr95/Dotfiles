" Configurações gerais
filetype plugin indent on
syntax on
set title
set encoding=utf-8
set backspace=indent,eol,start
set noerrorbells
set confirm
set hidden
set splitbelow
set splitright
set path=.,**
set mouse=a
set clipboard=unnamedplus
" Undo
set undodir=~/.vim/undodir
set undofile
" Interface
set nowrap
set linebreak
set nolist
set listchars=tab:›-,space:·,trail:◀,eol:↲
set number
set relativenumber
set scrolloff=2
set cursorline
" set cursorcolumn
" Folds
set foldmethod=syntax
set foldlevel=99
" Terminal
let &t_SI="\e[6 q"
let &t_EI="\e[2 q"
" Indentação
set autoindent
set smartindent
" Tabs e Espaços
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
" Busca
" set ignorecase
set smartcase
set incsearch
set hls
let @/ = ""
" Wildmenu
set wildmenu
set wildmode=longest,full
" set wildoptions=pum

" Statusline
set noshowmode
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_statusline_ontop=0
let g:airline_theme='base16_twilight'

" Themes
source ~/.vim/themes/xcodedark.vim

call plug#begin()
" Interface e temas
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
" Gerenciamento de arquivos e navegação
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
" Autocomplete e snippets
Plug 'shougo/neocomplete.vim'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
" Suporte a linguagem e frameworks
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
" Ferramenta de suporte css e html
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
" Autocomple para python
Plug 'davidhalter/jedi-vim'
" Javascript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'mhartington/oceanic-next'
" Ferramentas de desenvolvimento e utilidades
Plug 'dense-analysis/ale'
Plug 'preservim/nerdcommenter'
call plug#end()

" COC
let g:coc_global_extensions = ['coc-python', 'coc-yaml', 'coc-html', 'coc-tsserver', 'coc-json', 'coc-css']

" Python
let g:ale_linters = {
\   'python': ['flake8', 'pyright', 'bandit'],
\}
" Config flake8, linter, mensagens de erros e avisos
let g:ale_python_flake8_options = '--max-line-length=100 --extend-ignore=E203'
let g:ale_python_pyright_options = '--enable-type-checking'
" Config black, analisador de formatação
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'python': ['black', 'isort'],
\}
let g:ale_python_black_options = '--line-length 100'
" Confg isort, analise de imports
let g:ale_python_isort_options = '--profile black -l 100'

" Configuração do ALE para JavaScript/React
let g:ale_linters = {
\   'javascript': ['eslint', 'tsserver'],
\   'typescript': ['eslint', 'tsserver'],
\   'javascriptreact': ['eslint', 'tsserver'],
\   'typescriptreact': ['eslint', 'tsserver'],
\ }

" Key-maps
nnoremap <C-q>q :quit<CR>
nnoremap <C-s>w :w<CR>
" Sidebar
nmap <C-e>e :NERDTreeToggle<CR>
" nnoremap <C-e>e :25Lex<CR>
" Pesquisa|FZF
map <C-f>d :FZF<CR>
map <C-f>t :Ag<CR>
" buffers
map <C-a>b :Buffers<CR>
map <C-a>a :tab ball<CR>
map <C-a>n :bn<CR>
map <C-a>p :bp<CR>
map <C-a>c :bd<CR>
" Executar Terminal
map <C-t> :term<CR>
" Autoclose
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
" Aumentar o tamanho do split vertical em 10 colunas
nnoremap <silent> <C-Left> :vertical resize +10<CR>
nnoremap <silent> <C-Right> :vertical resize -10<CR>
" Aumentar/diminuir o tamanho do split horizontal em 10 linhas
nnoremap <silent> <C-Up> :resize +10<CR>
nnoremap <silent> <C-Down> :resize -10<CR>
