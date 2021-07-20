-------------
-- Aliases --
-------------
local g = vim.g
local fn = vim.fn
local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

g.mapleader = " "

if fn.maparg('gh', 'n') ~= '' then unmap('n', 'gh') end

if fn.maparg('<C-L>', 'n') == '' then
    map('n', '<C-L>',
        ':nohlsearch<C-R>=has("diff")?"<Bar>diffupdate":""<CR><CR><C-L>',
        {silent = true, noremap = true})
end

-- Candidates
map('n', '<localleader>f', '<cmd>Telescope find_files<cr>', {noremap = true})
--

map('n', '<M-f>', '<cmd>Files<CR>', {noremap = true, silent = true})
map('n', '<leader>/', ':Rg<space>', {noremap = true})
map('n', '<leader>?', '<cmd>Helptags<CR>', {noremap = true, silent = true})
map('n', '<leader>F', '<cmd>GFiles --others --exclude-standard<CR>',
    {noremap = true, silent = true})
map('n', '<leader>L', '<cmd>Lines<CR>', {noremap = true, silent = true})
map('n', '<leader>N', '<cmd>bp<CR>', {noremap = true})
map('n', '<leader>T', '<cmd>BTags<CR>', {noremap = true, silent = true})
map('n', '<leader>[', '<cmd>cprev<CR>', {noremap = true})
map('n', '<leader>]', '<cmd>cnext<CR>', {noremap = true})
map('n', '<leader>b', '<cmd>Buffers<CR>', {noremap = true, silent = true})
map('n', '<leader>ce', ':e <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})
map('n', '<leader>cse', ':sp <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})
map('n', '<leader>cte', ':tabe <C-R>=expand("%:p:h") . "/"<CR>',
    {noremap = true})
map('n', '<leader>cve', ':vsp <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})
map('n', '<leader>f', '<cmd>GFiles<CR>', {noremap = true, silent = true})
map('n', '<leader>h', '<cmd>History<CR>', {noremap = true, silent = true})
map('n', '<leader>l', '<cmd>BLines<CR>', {noremap = true, silent = true})
map('n', '<leader>n', '<cmd>bn<CR>', {noremap = true})
map('n', '<leader>un', '<cmd>setlocal rnu!<CR>', {noremap = true})
map('n', '<leader>uc', '<cmd>setlocal cursorcolumn!<CR>', {noremap = true})
map('n', '<leader>sh', '<cmd>split <Bar> ter<CR>', {noremap = true})
map('n', '<leader>t', '<cmd>Tags<CR>', {noremap = true, silent = true})
map('n', '<leader>5', '<cmd>norm V$%<CR>', {noremap = true, silent = true})
map('n', '<leader>vsh', '<cmd>vsplit <Bar> ter<CR>', {noremap = true})
map('n', '<leader>w', '<cmd>Windows<CR>', {noremap = true, silent = true})
map('n', '<leader>x', '<cmd>bd<CR>', {noremap = true})
map('n', 'gQ', 'mmgggqG\'m', {noremap = true, silent = true})
map('n', 'g/', "<cmd>lua require'hop'.hint_char2()<cr>",
    {noremap = true, silent = true})
map('n', 'gh', "<cmd>lua require'hop'.hint_lines()<cr>",
    {noremap = true, silent = true})

map('i', '<CR>', 'compe#confirm("<CR>")',
    {silent = true, expr = true, noremap = true})

map('t', '<C-W>n', '<C-\\><C-n>', {noremap = true})
map('t', '<M-h>', '<C-\\><C-n><C-w>h', {noremap = true})
map('t', '<M-j>', '<C-\\><C-n><C-w>j', {noremap = true})
map('t', '<M-k>', '<C-\\><C-n><C-w>k', {noremap = true})
map('t', '<M-l>', '<C-\\><C-n><C-w>l', {noremap = true})

map('c', '<C-L>', '<C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})

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
