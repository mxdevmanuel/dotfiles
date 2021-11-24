local fn = vim.fn
local M = {}

local projectvars = '.projectvars'

function M.setup()
    vim.api.nvim_exec([[
        augroup ReadVars
            autocmd!
            autocmd DirChanged * lua require'environment'.read_vars()
        augroup END
    ]], false)
end

function M.read_vars()
    local context_manager = require "plenary.context_manager"
    local with = context_manager.with
    local open = context_manager.open

    if fn.filereadable(projectvars) == 1 then
        with(open(projectvars), function(reader)
            local str = reader:read("*all")
            for s in str:gmatch("[^\r\n]+") do
                local p, o = string.find(s, "=")
                local name = (string.sub(s, 0, p - 1))
                local value = (string.sub(s, p + 1))
                vim.env[name] = value
            end

            vim.cmd("LspRestart all")

            if packer_plugins["nvim-notify"] then
                require 'notify'("Environment loaded", vim.lsp.log_levels.INFO,
                                 {
                    title = "Read vars",
                    timeout = 2000
                })
            else
                vim.notify("Environment loaded")
            end
        end)
    end
end

return M
