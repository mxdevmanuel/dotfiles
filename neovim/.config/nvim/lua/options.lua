-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local env = vim.env -- environment variables
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
w.cursorline = true
w.foldmethod = 'expr'
w.foldexpr = 'nvim_tressiter#foldexpr()'
w.statusline =
    "%<%#StatusLineGit#%<%{FugitiveStatusline()} %f %#StatusLine#%h%m%r%=%#StatusLineFt# %y %#StatusLine# %-14.(%l,%c%V%) %P"

o.autoread = true
o.foldlevelstart = 20
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

local undodir = "/tmp/.vim-undo-dir"
if fn.isdirectory(undodir) == 0 then fn.mkdir(undodir, "", 0755) end
o.undodir = undodir
o.undofile = true

-- correct
local swapdir = "/tmp/.vim-swap-dir"
if fn.isdirectory(swapdir) == 0 then fn.mkdir(swapdir, "", 0755) end
o.directory = swapdir

-- Table options
opt.backspace = {"indent", "eol", "start"}
opt.wildoptions = {"tagfile"}
opt.fileencodings = {'utf-8'}
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.virtualedit = {'block'}

opt.shortmess = opt.shortmess + 'Ic'

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

g.fzf_layout = {
    window = {
        width = 0.9,
        height = 0.6
    }
}

g.dashboard_default_executive = 'fzf'

g.dashboard_custom_shortcut = {
    last_session = '',
    find_history = '',
    find_file = '',
    new_file = '',
    change_colorscheme = '',
    find_word = '',
    book_marks = ''
}

g.dashboard_custom_header = {
    ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝'
}

g.netrw_banner = 0
g.loaded_matchit = 1

-- g.indent_blankline_char = "┆"
-- g.indent_blankline_show_first_indent_level = false

-- GUI Options

if (vim.g.neovide ~= nil and vim.env.SWAYSOCK ~= nil) then
    o.guifont = "SF Mono:h12"
elseif (vim.g.neovide ~= nil) then
    o.guifont = "SF Mono:h16"
else
    o.guifont = "SF Mono:h12"
end
