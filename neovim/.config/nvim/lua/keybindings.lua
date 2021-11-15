-------------
-- Aliases --
-------------
local g = vim.g
local fn = vim.fn
local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

local mappings = {
    {'n', '<M-f>', '<cmd>Telescope find_files<cr>'},
    {'n', '<leader>/', '<cmd>Telescope live_grep<cr>'},
    {'n', '<leader>"', '<cmd>Telescope registers<cr>'},
    {'n', '<leader>5', '<cmd>norm V$%<CR>'},
    {'n', '<leader>?', '<cmd>Telescope help_tags<CR>'},
    {'n', '<leader>G', '<cmd>Telescope git_status<CR>'},
    {'n', '<leader>N', '<cmd>bp<CR>'},
    {'n', '<leader>T', '<cmd>Telescope treesitter<CR>'},
    {'n', '<leader>[', '<cmd>cprev<CR>'}, {'n', '<leader>]', '<cmd>cnext<CR>'},
    {'n', '<leader>a', '<cmd>NvimTreeToggle<CR>'},
    {'n', '<leader>b', '<cmd>Telescope buffers<CR>'},
    {'n', '<leader>f', '<cmd>Telescope git_files<CR>'},
    {'n', '<leader>h', '<cmd>Telescope oldfiles<CR>'},
    {'n', '<leader>n', '<cmd>bn<CR>'},
    {'n', '<leader>sh', '<cmd>split <Bar> ter<CR>'},
    {'n', '<leader>t', '<cmd>Telescope tags<CR>'},
    {'n', '<leader>uc', '<cmd>setlocal cursorcolumn!<CR>'},
    {'n', '<leader>un', '<cmd>setlocal rnu!<CR>'},
    {'n', '<leader>vsh', '<cmd>vsplit <Bar> ter<CR>'},
    {'n', '<leader>x', '<cmd>bd<CR>'},
    {'n', '<localleader>f', '<cmd>Telescope find_files<CR>'},
    {'n', 'gQ', 'mmgggqG\'m'}, -- Comments to keep
    {'n', 'gh', "<cmd>HopChar2<cr>"}, -- one entry
    {'t', '<M-h>', '<C-\\><C-n><C-w>h'}, -- per line
    {'t', '<M-j>', '<C-\\><C-n><C-w>j'}, -- when formatting
    {'t', '<M-k>', '<C-\\><C-n><C-w>k'}, -- TODO(mxdevmanuel)
    {'t', '<M-l>', '<C-\\><C-n><C-w>l'}, -- find a better way
    {'t', '<M-n>', '<C-\\><C-n>'} -- to do this
}

g.mapleader = " "

if fn.maparg('gh', 'n') ~= '' then unmap('n', 'gh') end

if fn.maparg('<C-L>', 'n') == '' then
    map('n', '<C-L>',
        ':nohlsearch<C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><C-L>', {
        silent = true,
        noremap = true
    })
end

if fn.maparg('<C-L>', 'c') == '' then
    map('c', '<C-L>', '<C-R>=expand("%:p:h") . "/"<CR>', {
        noremap = true
    })
end

for i, v in ipairs(mappings) do
    map(v[1], v[2], v[3], {
        noremap = true,
        silent = true
    })
end

vim.cmd([[
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
	cnoreabbrev wc WriteToClipboard
]])

