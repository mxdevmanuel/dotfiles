-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local env = vim.env -- environment variables
local exec = vim.api.nvim_exec -- execute Vimscript
-- local map = vim.api.nvim_set_keymap  -- set global keymap
local fn = vim.fn -- call Vim functions
local g = vim.g -- global variables
local o = vim.o -- global options
local b = vim.bo -- buffer-scoped options
local w = vim.wo -- windows-scoped options
local opt = vim.opt -- table options (TODO: wanna know difference with `o`)

b.expandtab = true

w.number = true
w.relativenumber = true
w.signcolumn = 'yes:1'
w.foldmethod = 'syntax'
w.cursorline = true
w.statusline =
    "%<%#StatusLineGit#%<%{FugitiveStatusline()}%#StatusLineFn# %f %#StatusLine#%h%m%r%=%#StatusLineFt#%y%#StatusLine# %-14.(%l,%c%V%) %P"

o.autoread = true
o.background = 'dark'
o.foldlevelstart = 20
o.guifont ="SF Mono:h16"
o.hidden = true
o.hlsearch = true
o.inccommand = 'nosplit'
o.incsearch = true
o.laststatus = 2
o.lazyredraw = true
o.mouse = 'a'
o.mousemodel = 'popup'
o.pastetoggle = '<F11>'
o.scrolloff = 3
o.showcmd = true
o.showmatch = true
o.showmode = true
o.smarttab = true
o.smartindent = true
o.splitbelow = true
o.splitright = true
o.syntax = 'enable'
o.termguicolors = true
o.updatetime = 300

if fn.executable("rg") == 1 then
    o.grepprg = 'rg --vimgrep --no-heading --hidden --glob="!.git/"'
    o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

if fn.has('mouse_sgr') ~= 0 then o.ttymouse = 'sgr' end

if fn.isdirectory("/tmp/.vim-undo-dir") == 0 then
    fn.mkdir("/tmp/.vim-undo-dir", "", 0755)
end
o.undodir = '/tmp/.vim-undo-dir'
o.undofile = true

if fn.isdirectory("/tmp/.vim-swap-dir") == 0 then
    fn.mkdir("/tmp/.vim-swap-dir", "", 0755)
end
o.directory = '/tmp/.vim-swap-dir'

-- Table options
opt.backspace = {"indent", "eol", "start"}
opt.wildoptions = {"tagfile"}
opt.fileencodings = {'utf-8'}
opt.completeopt = {'menuone', 'noselect'}

opt.shortmess = opt.shortmess - 'I'
opt.shortmess = opt.shortmess + 'c'

if (fn.has('langmap') ~= 0 and fn.exists('+langremap') ~= 0) then
    -- Prevent that the langmap option applies to characters that result from a
    -- mapping.  If set (default), this may break plugins (but it's backward
    -- compatible).
    o.langremap = false
end

-- plugins variables
env.NOTMUX = 1
env.FZF_DEFAULT_OPTS =
    (vim.env.FZF_DEFAULT_OPTS == nil and ' --layout=reverse' or
        vim.env.FZF_DEFAULT_OPTS .. ' --layout=reverse')

g.fzf_layout = {window = {width = 0.9, height = 0.6}}

g.startify_bookmarks = {
    '~/Code/Client/client-backend', '~/Code/Client', '~/Code/Luzoft', '~/Code',
    '~/.dotfiles'
}
g.startify_change_to_vcs_root = 1
g.startify_custom_header = 'startify#fortune#boxed()'

g.netrw_banner = 0

g.indent_blankline_char = "┆"
g.indent_blankline_show_first_indent_level = false
