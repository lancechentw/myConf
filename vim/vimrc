set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'Lokaltog/vim-powerline'
Bundle 'ap/vim-css-color'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'scrooloose/nerdtree'
Bundle 'msanders/snipmate.vim'
Bundle 'tpope/vim-surround'
"Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"Bundle 'tpope/vim-rails.git'
" vim-scripts repos
"Bundle 'L9'
"Bundle 'FuzzyFinder'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..


set t_Co=256
colorscheme desert

syntax on
set modeline
set showmatch
set backspace=indent,eol,start 
set ruler
set number
set wildmenu
set wildmode=list:longest,full
set laststatus=2
nmap <F2> :set number! number?<CR>
nmap <F3> :NERDTreeToggle<CR>
nmap <F4> :set paste! paste?<CR>

" Cursor line
autocmd InsertLeave * set cursorline
autocmd InsertEnter * set nocursorline

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan

" encodings
set fencs=ucs-bom,utf-8,big5,cp936,gb18030,euc-jp,euc-kr,latin1
set enc=utf-8 fenc=utf-8 tenc=utf-8
set fileformat=unix

" save view
autocmd     BufWinLeave ?* silent mkview
autocmd     BufWinEnter ?* silent loadview

set et ts=4 sw=4 sts=4
" easytab
nmap    <tab> v>
nmap    <s-tab> v<
xmap    <tab> >gv
xmap    <s-tab> <gv

let mapleader=','
" Moving around and tabs
nmap <LEADER>tc :tabnew<CR>
nmap <LEADER>te :tabedit<SPACE>
nmap <LEADER>tm :tabmove<SPACE>
nmap <LEADER>tk :tabclose<CR>
nmap <C-H> :tabprev<CR>
nmap <C-L> :tabnext<CR>

" Folding
set foldenable
set foldmethod=syntax
set foldlevel=10000
set foldcolumn=3
nnoremap <SPACE> za

" Indent
set autoindent
set smartindent

" Markdown to HTML
nmap <LEADER>md :%!markdown --html4tags<CR>

" php 
let php_sql_query=1
let php_htmlInStrings=1

