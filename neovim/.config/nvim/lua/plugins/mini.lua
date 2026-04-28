require('mini.pairs').setup()

require('mini.surround').setup({
  mappings = {
    add = 'gsa',
    delete = 'gsd',
    find = 'gsf',
    find_left = 'gsF',
    highlight = 'gsh',
    replace = 'gsr',
    update_n_lines = 'gsn',
    suffix_last = 'l',
    suffix_next = 'n',
  },
})

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

require('mini.statusline').setup()

require('mini.indentscope').setup()

local pick = require('mini.pick')
local extra = require('mini.extra')
pick.setup()
extra.setup()

vim.keymap.set('n', '<leader>ff', function() extra.pickers.git_files() end, { desc = '[F]ind git [F]iles' })
vim.keymap.set('n', '<leader>fa', pick.builtin.files, { desc = '[F]ind [A]ll files' })
vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fb', pick.builtin.buffers, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fh', function() extra.pickers.oldfiles() end, { desc = '[F]ind [H]istory files' })
vim.keymap.set('n', '<leader>fo', function() extra.pickers.buf_lines({ scope = 'current' }) end, { desc = '[F]ind lines' })
vim.keymap.set('n', '<leader>fs', function() extra.pickers.lsp({ scope = 'document_symbol' }) end, { desc = '[F]ind [S]ymbols' })
vim.keymap.set('n', '<leader>fd', function() extra.pickers.diagnostic({ scope = 'current' }) end, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>ws', function() extra.pickers.lsp({ scope = 'workspace_symbol' }) end, { desc = '[W]orkspace [S]ymbols' })
vim.keymap.set('n', '<leader>wd', function() extra.pickers.diagnostic({ scope = 'all' }) end, { desc = '[W]orkspace [D]iagnostics' })
