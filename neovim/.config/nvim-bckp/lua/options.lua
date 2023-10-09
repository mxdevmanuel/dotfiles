-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local env = vim.env -- environment variables
local fn = vim.fn -- call Vim functions
local g = vim.g -- global variables
local o = vim.o -- global options
local w = vim.wo -- windows-scoped options
local opt = vim.opt -- table options (TODO: wanna know difference with `o`)

w.colorcolumn = '99999'
w.cursorline = true
w.foldmethod = "indent"
w.number = true
w.relativenumber = true
w.signcolumn = 'yes:1'

o.autoread = true
o.foldlevelstart = 20
o.hidden = true
o.hlsearch = true
o.inccommand = 'nosplit'
o.incsearch = true
o.laststatus = 3
o.lazyredraw = true
o.mouse = 'a'
o.mousemodel = 'popup'
o.pastetoggle = '<F11>'
o.scrolloff = 3
o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,globals"
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
    o.grepprg = 'rg --vimgrep --no-heading --hidden --glob=\'!.git/\''
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
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.fileencodings = {'utf-8'}
opt.virtualedit = {'block'}
opt.wildignore = {"node_modules/*", "**/node_modules/*", ".git/*", "**/.git/*", "**/dist/*", "dist/*"}
opt.wildoptions = {"tagfile"}

opt.shortmess = opt.shortmess + 'Ic'

if (fn.has('langmap') ~= 0 and fn.exists('+langremap') ~= 0) then
    -- Prevent that the langmap option applies to characters that result from a
    -- mapping.  If set (default), this may break plugins (but it's backward
    -- compatible).
    o.langremap = false
end

-- plugins variables
env.NOTMUX = 1

g.netrw_banner = 0
g.loaded_matchit = 1
g.EditorConfig_exclude_patterns = {'fugitive://.*', 'scp://.*', 'NvimTree*'}
-- g.neovide_cursor_animation_length = 0

-- GUI Options

o.guifont = "SF Mono Powerline:h12"

if g.neovide ~= nil then require('environment').setup() end
