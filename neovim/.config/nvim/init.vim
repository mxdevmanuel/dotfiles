call plug#begin()

Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'freitass/todo.txt-vim'
Plug 'jiangmiao/auto-pairs'

" Colorschemes
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-solarized8'
Plug 'arcticicestudio/nord-vim'

" Wanna get rid of
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'

" VCS
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle' ,'NERDTreeFind']}
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': ['NERDTreeToggle' ,'NERDTreeFind']}

" Syntax
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'jparise/vim-graphql'

call plug#end()

" Manuel

" Maps
let mapleader = " "

map <C-k><C-b> :NERDTreeToggle<CR>
map <C-k><C-o> :NERDTreeFind<CR>
map <bs> <Plug>(easymotion-prefix)

nnoremap <C-p> :GFiles<CR>
nnoremap <Leader>f :GFiles<CR>
nnoremap <Leader>F :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>T :BTags<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>q :bd<CR>
nnoremap <Leader>hh :nohl<CR>
nnoremap <Leader>rr :set rnu!<CR>
nnoremap <Leader>/ :Rg<space>
nnoremap <Leader>? :Help<space>

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Settings
set laststatus=2
set noshowmode
set showcmd
set expandtab
set number
set rnu
set splitbelow
set splitright
set hidden
set signcolumn=yes
set updatetime=300
set backspace=indent,eol,start
set display+=lastline
set wildmenu
set background=dark
set incsearch
set hlsearch
set visualbell
set scrolloff=3
set autoread
set foldmethod=syntax
set foldlevelstart=20
set tags^=./.git/tags;
set smarttab
set pastetoggle=<F11>
set formatoptions+=j
set encoding=UTF-8
set cursorline
set lazyredraw
set ruler

syntax on
colorscheme gruvbox

" Use persistent history.
if !isdirectory("/tmp/.vim-undo-dir")
    call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile

if !isdirectory("/tmp/.vim-swap-dir")
    call mkdir("/tmp/.vim-swap-dir", "", 0700)
endif
set directory=/tmp/.vim-swap-dir

let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

let g:EditorConfig_exclude_patterns = ['fugitive://.\*']


let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"autocmd BufEnter * lcd %:p:h

if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
        diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
  endfunction
com! DiffSaved call s:DiffWithSaved()

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

function! s:SetGitRootTags()
	let root=system("git rev-parse --show-toplevel | tr -d '\\n'") . '/tags'
	exe "set tags+=" . root
endfunction
com! GitRootTags call s:SetGitRootTags()

command! Sw execute 'silent w !sudo tee % >/dev/null' | edit!
command! W write

" enable mouse
set mouse=a
if has('mouse_sgr')
    " sgr mouse is better but not every term supports it
    set ttymouse=sgr
endif

" change cursor shape for different editing modes, neovim does this by default
if !has('nvim')
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
        let &t_SR = "\<Esc>Ptmux;\<Esc>\e[4 q\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
    else
        let &t_SI = "\e[6 q"
        let &t_SR = "\e[4 q"
        let &t_EI = "\e[2 q"
    endif
endif

autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

autocmd FileType json let g:indentLine_enabled=0
autocmd FileType typescript set makeprg=make

autocmd FileType typescript,javascript nnoremap <buffer> K :!zeal "<cword>"&<CR><CR>
autocmd FileType typescript,javascript nnoremap <buffer> <silent> <F13> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

let javaScript_fold=1
let g:netrw_banner=0

let g:peekaboo_window="vert abo 30new"
let g:peekaboo_prefix="<F12>"
let g:peekaboo_ins_prefix="<F12>"

command! -bang -nargs=? -complete=dir PFiles
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

" Using floating windows of Neovim to start fzf
let $FZF_DEFAULT_OPTS .= ' --layout=reverse'

function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.6)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

" Open Floating terminal
function! OpenTerm(cmd)
    call CreateCenteredFloatingWindow()
    call termopen(a:cmd, { 'on_exit': function('OnTermExit') })
endfunction

function! OnTermExit(job_id, code, event) dict
    if a:code == 0
        bd!
    endif
endfunction

autocmd TermOpen * startinsert
" Turn off line numbers etc
autocmd TermOpen * setlocal listchars= nonumber norelativenumber

" npm run menu
function! SelectNpmScript()
        if filereadable("./package.json")
                let st = readfile("./package.json")
                let package = json_decode(join(st, " "))
                if has_key(package, "scripts")
                        let b:ks = keys(package.scripts)
                        call fzf#run(fzf#wrap( {'source': b:ks, 'sink': function('RunNpmScript')} ))
                endif
        else
                echo "No package.json found"
	endif
endfunction

function! RunNpmScript(result)
        call OpenTerm("npm run " . a:result)
endfunction

nnoremap <silent> <F10> :call SelectNpmScript()<CR>

