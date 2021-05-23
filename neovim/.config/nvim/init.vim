" vi: foldmethod=marker

" Setup {{{
filetype indent plugin on

lua << EOF

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use 'junegunn/vim-peekaboo'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-eunuch'
  use 'mattn/emmet-vim'
  use 'editorconfig/editorconfig-vim'
  use 'Yggdroot/indentLine'
  use 'jiangmiao/auto-pairs'
  use 'justinmk/vim-sneak'
  use 'mhinz/vim-startify'
  use 'voldikss/vim-skylight'

  -- Snippets
  use 'hrsh7th/vim-vsnip' 
  use 'hrsh7th/vim-vsnip-integ'
  use 'cstrap/python-snippets' 
  use 'ylcnfrht/vscode-python-snippet-pack' 
  use 'xabikos/vscode-javascript' 
  use 'Nash0x7E2/awesome-flutter-snippets'

  -- Documentation generator
  use 'kkoomen/vim-doge'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'kabouzeid/nvim-lspinstall'

  -- Colorschemes
  use 'morhetz/gruvbox'
  use 'tanvirtin/monokai.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- VCS
  use 'tpope/vim-fugitive'
  use 'junegunn/gv.vim'
  use 'airblade/vim-gitgutter'

  -- Syntax
  use 'sheerun/vim-polyglot'
  use 'norcalli/nvim-colorizer.lua'

  use 'kyazdani42/nvim-web-devicons'
end)
EOF
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
" }}}

" Maps {{{ 
let mapleader = " "

noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
noremap <Leader>E :tabe <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <silent> <leader>sh :call SplitTerm()<CR>
nnoremap <silent> <leader>vsh :call SplitTerm("y")<CR>
nnoremap <leader>. :lcd %:p:h<CR>
tnoremap <C-w>n <C-\><C-n>

nnoremap <localleader>f :GFiles --others --exclude-standard<CR>
nnoremap <localleader>F :Files<CR>
nnoremap <Leader>f <cmd>Telescope git_files<CR>
nnoremap <Leader>F :GFiles?<CR>
nnoremap <Leader>t <cmd>Telescope tags<CR>
nnoremap <Leader>T :BTags<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>b <cmd>Telescope buffers<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>/ :Rg<space>
nnoremap <Leader>* <cmd>Telescope grep_string<CR>
nnoremap <Leader>? <cmd>Telescope help_tags<CR>

nnoremap <silent><localleader>c :set cursorcolumn!<CR>
nnoremap <Leader>rr :set rnu!<CR>
nnoremap <silent><Leader>q :bd<CR>

nnoremap <silent><Leader>% :norm V$%<CR>

"" Buffer nav
noremap <leader>N :bp<CR>
noremap <leader>n :bn<CR>
nnoremap [l :cprev<CR>
nnoremap ]l :cnext<CR>

nnoremap gQ mmgggqG'm

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
set shortmess+=c
set completeopt+=menuone,noinsert,noselect
set completeopt-=preview
set statusline=%#DiffAdd#%<%{FugitiveStatusline()}%#StatusLine#\ %f\ %h%m%r%=%y\ %-14.(%l,%c%V%)\ %P

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
if hr >= 18
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

if &background == 'dark'
  colorscheme monokai
else
  colorscheme gruvbox
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
autocmd FileType typescript,javascript,javascriptreact,typescriptreact,dart,python nnoremap <buffer> <silent> <leader>p :Skylight<CR>
autocmd FileType c,cpp set formatprg=clang-format
autocmd FileType go set formatprg=gofmt
autocmd FileType python setlocal formatprg=autopep8\ -
autocmd BufRead,BufNewFile .envrc set filetype=sh


let g:prettier#autoformat = 0
autocmd BufWritePre *.tsx exec "%s/class=/className=/eg"
autocmd BufWritePre *.rs RustFmt
autocmd BufWritePre *.tf TerraformFmt

if exists('$AUTOFORMAT')
  " autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
endif

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

let g:sneak#label = 1

let $NOTMUX=1

let g:startify_bookmarks = ['~/Code/Client/client-backend', '~/Code/Client', '~/Code/Luzoft', '~/Code', '~/.dotfiles']
let g:startify_change_to_vcs_root = 1
let g:startify_custom_header = startify#fortune#boxed()

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_smart_case = 1

let g:completion_enable_snippet = 'vim-vsnip'

lua << EOF
--require('lualine').setup{options = {theme = 'gruvbox'} }
require'lspinstall'.setup()
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  require'completion'.on_attach()

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=false }
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<space>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>gq", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
 local servers = { "dartls" }
 for _, lsp in ipairs(servers) do
   nvim_lsp[lsp].setup { on_attach = on_attach }
 end
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{ on_attach = on_attach }
end

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
  },
}
EOF
