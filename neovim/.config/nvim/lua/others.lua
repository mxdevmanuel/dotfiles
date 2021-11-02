local M = {}

function M.gitsigns()
    if packer_plugins["plenary.nvim"] and
        not packer_plugins["plenary.nvim"].loaded then
        vim.api.nvim_command('PackerLoad plenary.nvim')
    end
    require('gitsigns').setup({
        signs = {
            add = {
                -- hl = 'CustomGitSignsAdd',
                hl = 'GitSignsAdd',
                text = '+',
                numhl = 'GitSignsAddNr',
                linehl = 'GitSignsAddLn'
            },
            change = {
                -- hl = 'CustomGitSignsChange',
                hl = 'GitSignsChange',
                text = '•',
                numhl = 'GitSignsChangeNr',
                linehl = 'GitSignsChangeLn'
            },
            delete = {
                -- hl = 'CustomGitSignsDelete',
                hl = 'GitSignsDelete',
                text = '-',
                numhl = 'GitSignsDeleteNr',
                linehl = 'GitSignsDeleteLn'
            },
            topdelete = {
                -- hl = 'CustomGitSignsDelete',
                hl = 'GitSignsDelete',
                text = '‾',
                numhl = 'GitSignsDeleteNr',
                linehl = 'GitSignsDeleteLn'
            },
            changedelete = {
                -- hl = 'CustomGitSignsDelete',
                hl = 'GitSignsChange',
                text = '~',
                numhl = 'GitSignsChangeNr',
                linehl = 'GitSignsChangeLn'
            }
        },
        numhl = false
    })
end

function M.dap()
            local dap = require('dap')
            dap.adapters.python = {
                type = 'executable',
                command = os.getenv('VIRTUAL_ENV') .. '/bin/python',
                args = {'-m', 'debugpy.adapter'}
            }
end

return M
