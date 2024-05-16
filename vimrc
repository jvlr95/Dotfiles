
" Configurações gerais
" -----------------------------------------------------------------------------
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
set tags=./tags,tags;$HOME
set clipboard=unnamedplus
"-----------------------------------------------------------------------------
set path=.,**
set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undodir
"-----------------------------------------------------------------------------
set nowrap
set linebreak
set nolist
set listchars=tab:›-,space:·,trail:◀,eol:↲
"-----------------------------------------------------------------------------
set number
set relativenumber
set scrolloff=2
set cursorline
set cursorcolumn
" Folds
" -----------------------------------------------------------------------------
set foldmethod=syntax
set foldlevel=99
"-----------------------------------------------------------------------------
let &t_SI="\e[6 q"
let &t_EI="\e[2 q"
"-----------------------------------------------------------------------------
set autoindent
set smartindent
"-----------------------------------------------------------------------------
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=2
"-----------------------------------------------------------------------------
set smartcase
set incsearch
set hls
let @/ = ""
" -----------------------------------------------------------------------------
set complete+=kspell
set completeopt=menuone,longest
set shortmess+=c
" -----------------------------------------------------------------------------
set spelllang=pt_br,en
set nospell
" -----------------------------------------------------------------------------
set wildmenu
set wildmode=longest,full
"-----------------------------------------------------------------------------
set noshowmode
set laststatus=2
" -----------------------------------------------------------------------------
hi statusline   cterm=NONE ctermfg=0 ctermbg=7   guibg=#C1C2D0 guifg=#000000
hi statuslinenc cterm=NONE ctermfg=0 ctermbg=240 guibg=#616270 guifg=#000000
" -----------------------------------------------------------------------------
augroup ModeEvents
    autocmd!
    au InsertEnter * hi statusline cterm=NONE ctermfg=0 ctermbg=10 guibg=#7BC86F
    au InsertLeave * hi statusline cterm=NONE ctermfg=0 ctermbg=7 guibg=#C1C2D0
    au ModeChanged *:[vV\x16]* hi statusline cterm=NONE ctermfg=0 ctermbg=13 guibg=#C990DC
    au Modechanged [vV\x16]*:* hi statusline cterm=NONE ctermfg=0 ctermbg=7 guibg=#C1C2D0
augroup end

function! LoadStatusLine()

    let g:left_sep='│'
    let g:right_sep='│'

    let g:currentmode={
        \ 'n'  : 'Normal',
        \ 'no' : 'Normal-Operator Pending',
        \ 'v'  : 'Visual',
        \ 'V'  : 'V-Line',
        \ '' : 'V-Block',
        \ 's'  : 'Select',
        \ 'S'  : 'S-Line',
        \ '' : 'S-Block',
        \ 'i'  : 'Insert',
        \ 'R'  : 'Replace',
        \ 'Rv' : 'V-Replace',
        \ 'c'  : 'Command',
        \ 'cv' : 'Vim Ex',
        \ 'ce' : 'Ex',
        \ 'r'  : 'Prompt',
        \ 'rm' : 'More',
        \ 'r?' : 'Confirm',
        \ '!'  : 'Shell',
        \ 't'  : 'Terminal'
        \}

    set statusline=\ %{toupper(g:currentmode[mode()])}
    " set statusline=\ %{toupper(mode())}
    set statusline+=\ %{left_sep}
    set statusline+=\ %n
    set statusline+=\ %{left_sep}
    set statusline+=\ %f%m\ %y
    set statusline+=\ %{left_sep}
    set statusline+=\ %{&ff}\ %{&fenc!=''?&fenc:&enc}
    set statusline+=\ %{left_sep}
    set statusline+=\ %=
    set statusline+=\ %{right_sep}
    set statusline+=\ %l/%L,%v
    set statusline+=\ %{right_sep}
    set statusline+=\ %P\ 

endfunction

call LoadStatusLine()
" -----------------------------------------------------------------------------
hi Normal guibg=NONE ctermbg=NONE
hi CursorLine guibg=#202130
hi Comment cterm=italic gui=italic
hi VertSplit ctermbg=NONE guibg=NONE ctermfg=7 guifg=#c1c2d0
hi TabLine      guifg=#9192a0 guibg=#303140 gui=none
hi TabLineSel   guifg=#a1a2b0 guibg=#101120 gui=bold
hi TabLineFill  guifg=#9192a0 guibg=#303140 gui=none
hi Visual guifg=NONE guibg=#303140
" -----------------------------------------------------------------------------
source ~/.vim/themes/sonokai.vim
" -----------------------------------------------------------------------------
call plug#begin()
" Gerenciamento de arquivos e navegação
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Suporte a linguagem e frameworksPlug 'sheerun/vim-polyglot'
Plug 'sheerun/vim-polyglot'
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
" Ferramentas de desenvolvimento e utilidades
Plug 'preservim/nerdcommenter'
call plug#end()
" -----------------------------------------------------------------------------
" COC
let g:coc_global_extensions = ['coc-snippets', 'coc-pyright', 'coc-jedi', 'coc-python', 'coc-yaml', 'coc-html', 'coc-tsserver', 'coc-react-refactor', 'coc-json', 'coc-css', 'coc-pairs']
" -----------------------------------------------------------------------------
" Key-maps
nnoremap <C-q>q :quit<CR>
nnoremap <C-s>w :w<CR>
" Sidebar
" nmap <C-e>e :NERDTreeToggle<CR>
nmap <C-e>e :25Lex<CR>
" Split
nmap <C-v>v :vsplit<CR>
nmap <C-h>h :split <CR>
" Pesquisa|FZF
map <C-f>f :FZF<CR>
map <C-f>g :Ag<CR>
map <C-f>b :Buffers<CR>
" buffers
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
" Use Tab para autocompletar e Enter para confirmar
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" -----------------------------------------------------------------------------
" Coc Snippets 
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'
" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
" -----------------------------------------------------------------------------
