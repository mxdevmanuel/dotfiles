" vi: foldmethod=marker

" Setup {{{
filetype indent plugin on

" Install vim plug if not insalled
let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif
" }}}

" Plugins {{{
call plug#begin(expand('~/.config/nvim/plugged'))

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'Yggdroot/indentLine'
Plug 'freitass/todo.txt-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'kkoomen/vim-doge'
Plug 'justinmk/vim-sneak'

" Thinking of throwing away
Plug 'honza/vim-snippets' " along with coc-snippets

" Colorschemes
Plug 'morhetz/gruvbox'
Plug 'crusoexia/vim-monokai'
Plug 'rakr/vim-one'


" VCS
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle' ,'NERDTreeFind']}
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': ['NERDTreeToggle' ,'NERDTreeFind']}

" Syntax
Plug 'sheerun/vim-polyglot'
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
" }}}

" Maps {{{ 
let mapleader = " "

map <C-k><C-b> :NERDTreeToggle<CR>
map <C-k><C-o> :NERDTreeFind<CR>
map <bs> <Plug>(easymotion-prefix)

imap <C-space> <Plug>(coc-snippets-expand-jump)
nnoremap <Leader>gd <Plug>(coc-definition)

noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
noremap <Leader>E :tabe <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <silent> <leader>sh :call SplitTerm()<CR>
nnoremap <silent> <leader>vsh :call SplitTerm("y")<CR>
nnoremap <leader>. :lcd %:p:h<CR>
tnoremap <C-w>n <C-\><C-n>

nnoremap <localleader>f :GFiles --others --exclude-standard<CR>
nnoremap <localleader>F :Files<CR>
nnoremap <Leader>f :GFiles<CR>
nnoremap <Leader>F :GFiles?<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>T :BTags<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>/ :Rg<space>
nnoremap <Leader>* :Rg<space><C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>? :Help<CR>

nnoremap <silent><localleader>c :set cursorcolumn!<CR>
nnoremap <Leader>rr :set rnu!<CR>
nnoremap <silent><Leader>q :bd<CR>

nnoremap <silent><Leader>% :norm V$%<CR>

"" Buffer nav
noremap <leader>N :bp<CR>
noremap <leader>n :bn<CR>
nnoremap [l :cprev<CR>
nnoremap ]l :cnext<CR>

nnoremap gQ gggqG<C-o><C-o>

" Vim config 
nnoremap <F5> :e $MYVIMRC<CR>
nnoremap <S-F5> :source $MYVIMRC<CR>
nnoremap <F8> :call ShowBufferInfo()<CR>
nnoremap <silent> <Leader><F9> :DogeGenerate<CR>
nnoremap <silent> <F10> :call SelectNpmScript()<CR>

cnoremap <C-l> <C-r>=expand("%:p:h") . "/" <CR>
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
" }}} "

" Settings {{{
set laststatus=2
set showmode
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
set wildoptions-=pum
set background=dark
set incsearch
set inccommand=nosplit
set hlsearch
set visualbell
set scrolloff=3
set autoread
set foldmethod=syntax
set foldlevelstart=20
set smarttab
set smartindent
set pastetoggle=<F11>
set formatoptions+=j
set encoding=utf-8
set fileencodings=utf-8
set cursorline
set lazyredraw
set ruler
set guifont=SF\ Mono:h12
set shortmess-=I
set completeopt+=menuone
set statusline=%#GruvboxGreenSign#%<%{FugitiveStatusline()}%#StatusLine#\ %f\ %h%m%r%=%y\ %-14.(%l,%c%V%)\ %P

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading\ --hidden\ --glob='!.git/'
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

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

" enable mouse
set mouse=a
if has('mouse_sgr')
    " sgr mouse is better but not every term supports it
    set ttymouse=sgr
endif
set mousemodel=popup

" }}}

" Colorscheme config {{{
if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
        lua require'colorizer'.setup()
endif


let hr = (strftime('%H'))
if hr >= 19
        set background=dark
elseif hr >= 9
        set background=light
elseif hr >= 0
        set background=dark
endif

if !empty($FORCE_DARK)
        set background=dark
endif

let g:gruvbox_italic=1
colorscheme gruvbox

if !empty($MONOKAI)
        let g:monokai_term_italic = 1
        let g:monokai_gui_italic = 1
        colorscheme monokai
        set background=dark
endif

if !empty($ONE)
        let g:one_allow_italics = 1
        colorscheme one
        let is_dark=(&background == 'dark')
        if !is_dark 
                highlight Cursor guifg=white guibg=magenta
                highlight iCursor guifg=magenta guibg=grey
        endif
endif


let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

highlight TabLineSel guibg=Olive guifg=White
highlight Title guifg=#fbf1c7

let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif
 " }}}

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

command! Sw execute 'silent w !sudo tee % >/dev/null' | edit!
command! Bufonly %bd | e#

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

autocmd FileType json,markdown let g:indentLine_enabled=0
autocmd FileType typescript set makeprg=make
" autocmd FileType typescript,javascript,yaml,css,html,graphql set tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
autocmd FileType typescript,javascript,javascriptreact,typescriptreact,dart,python nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>
autocmd FileType c,cpp set formatprg=clang-format
autocmd FileType go set formatprg=gofmt

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

let g:prettier#autoformat = 0
autocmd BufWritePre *.tsx exec "%s/class=/className=/eg"
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
autocmd BufWritePre *.rs RustFmt
autocmd BufWritePre *.tf TerraformFmt

let javaScript_fold=1
let g:netrw_banner=0

let g:peekaboo_window="call CreateCenteredFloatingWindow()"
let g:peekaboo_prefix="<F12>"
let g:peekaboo_ins_prefix="<F12>"

" Using floating windows of Neovim to start fzf
let $FZF_DEFAULT_OPTS .= ' --layout=reverse'

function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.7)
    let height = float2nr(&lines * 0.7)
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

command! Wuzz call OpenTerm('wuzz')

autocmd TermOpen * startinsert
" Turn off line numbers etc
autocmd TermOpen * setlocal listchars= nonumber norelativenumber signcolumn=no

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }

" npm run menu
function! SelectNpmScript()
        if filereadable("./package.json")
                let st = readfile("./package.json")
                let package = json_decode(join(st, " "))
                if has_key(package, "scripts")
                        let b:ks = keys(package.scripts)
                        call fzf#run(fzf#wrap( {'source': b:ks, 'sink': {result -> execute("call OpenTerm(\"npm run \" . result)")}} ))
                endif
        else
                echo "No package.json found"
	endif
endfunction


function! SplitTerm(...)
        if empty(a:0)
                split
        else
                vsplit
        endif
        ter
endfunction

function! ShowBufferInfo()
        echo join([ &fileformat, &fileencoding, &filetype], " ")
endfunction

" Markdown preview
let g:mkdp_auto_start = !empty($NOTES)
let g:mkdp_browser = 'vimb'
let g:mkdp_refresh_slow = 1
let g:sneak#label = 1

