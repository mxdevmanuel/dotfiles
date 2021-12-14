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

function M.telescope()
    local telescope = require('telescope')

    telescope.setup()

    telescope.load_extension('fzf')
    telescope.load_extension('luasnip')
end

function ChangeProject()
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local previewers = require "telescope.previewers"

    local opts = require'telescope.themes'.get_dropdown();
    local dirpreviewer = previewers.new_termopen_previewer({
        get_command = function(entry, status)
            return {'exa', '--icons', '--git', entry.value}
        end
    })
    local find_command = opts.find_command

    if 1 == vim.fn.executable "find" and vim.fn.has "win32" == 0 then
        find_command = {
            "find", vim.fn.expand('~') .. "/Code", "-type", "d", "-and",
            "-name", ".git"
        }
    end

    if not find_command then
        print("You need to install find. " ..
                  "You can also submit a PR to add support for another file finder :)")
        return
    end

    opts.entry_maker = function(entry)
        local rep = entry:gsub('.git', '')
        return {
            value = rep,
            display = rep,
            ordinal = rep
        }
    end

    pickers.new(opts, {
        prompt_title = "cd to project",
        finder = finders.new_oneshot_job(find_command, opts),
        sorter = require'telescope.sorters'.get_generic_fuzzy_sorter({}),
        previewer = dirpreviewer,
        attach_mappings = function(prompt_bufnr, map)
            local function cd_to_project()
                local content =
                    require'telescope.actions.state'.get_selected_entry(
                        prompt_bufnr)
                vim.api.nvim_exec("cd " .. content.value, false)
                require'telescope.actions'.close(prompt_bufnr)
            end

            map('i', '<CR>', function(bufnr) cd_to_project() end)
            return true
        end

    }):find()
end

function M.dap()
    if packer_plugins["DAPInstall.nvim"] and
        not packer_plugins["DAPInstall.nvim"].loaded then
        vim.api.nvim_command('PackerLoad DAPInstall.nvim')
    end

    local dap_install = require("dap-install")

    dap_install.setup({
        installation_path = vim.fn.stdpath("data") .. "/dapinstall/"
    })

    local dbg_list =
        require("dap-install.api.debuggers").get_installed_debuggers()

    for _, debugger in ipairs(dbg_list) do dap_install.config(debugger, {}) end

    local dap = require('dap')
    local venv = os.getenv('VIRTUAL_ENV')
    local python = (venv ~= nil and venv or '/usr') .. '/bin/python'
    dap.adapters.python = {
        type = 'executable',
        command = python,
        args = {'-m', 'debugpy.adapter'}
    }
end

return M
