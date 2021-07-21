local Job = require 'plenary.job'
local fn = vim.fn

local nvm_extractor = 'extract_nvm.sh'

function LoadNVM()
    if (fn.executable(nvm_extractor) == 1 and fn.empty(vim.env.NVM_DIR) == 1) then
        Job:new({
            command = nvm_extractor,
            -- args = { '--files' },
            cwd = vim.env.HOME .. '/.local/bin',
            -- env = { ['a'] = 'b' },
            on_exit = vim.schedule_wrap(function(j, return_val)
                print(return_val)
                if (return_val == 2) then return end
                local x = j:result()
                for _, s in ipairs(x) do
                    p, o = string.find(s, "=")
                    local name = (string.sub(s, 0, p - 1))
                    local value = (string.sub(s, p + 1))
                    vim.env[name] = value
                end
            end)
        }):sync() -- or start()
    end
end
