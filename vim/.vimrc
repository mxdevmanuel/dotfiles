set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'chrisbra/Colorizer'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'jparise/vim-graphql'
Plug 'tpope/vim-surround'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
Plug 'leafgarland/typescript-vim'

call plug#end()

" Manuel

" Maps
map <C-k><C-b> :NERDTreeToggle<CR>
let mapleader = " "

nnoremap <Leader>f :GFiles<CR>
nnoremap <Leader>F :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>T :BTags<CR>
nnoremap <Leader>l :Rg<CR>
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>b :Buffers<CR>

inoremap { {<CR>}<ESC>ko
inoremap ( ()<ESC>i
inoremap [ []<ESC>i

" Settings
set laststatus=2
set noshowmode
set showcmd
set expandtab
set number
set splitbelow
set splitright
set hidden
set signcolumn=yes
set updatetime=300
set backspace   =indent,eol,start
set background=dark
set ttyfast
set incsearch
set hlsearch

syntax on
colorscheme manuel

let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
"autocmd BufEnter * lcd %:p:h

function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
        diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
  endfunction
com! DiffSaved call s:DiffWithSaved()

function! s:SetGitRootTags()
	let root=system("git rev-parse --show-toplevel | tr -d '\\n'") . '/tags'
	exe "set tags+=" . root
endfunction
com! GitRootTags call s:SetGitRootTags()
