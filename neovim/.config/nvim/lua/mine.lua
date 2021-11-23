local fn = vim.fn
local M = {}

local projectvars = '.projectvars'

function M.setup()
    vim.api.nvim_exec([[
	augroup ReadVars
		autocmd!
		autocmd DirChanged * lua require'mine'.readVars()
	augroup END
]], false)
end

function M.readVars()
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
        end)
    end
end

function M.split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

return M
