local Job = require 'plenary.job'
local fn = vim.fn

local envfile = '/tmp/envfile'

function LoadENV()
    Job:new({
        command = '/usr/bin/zsh',
        args = {
            '-i', '-c',
            [[ pushd $HOME ; d=`mktemp`; env > $d ; pushd ${OLDPWD} ; s=`mktemp` ; env > $s ;  diff $d $s | grep -E "^>" | grep -vE "DIRENV|OLDPWD|PWD" | tr -d ">" | tee $envfile ]]
        },
        cwd = '/home/manuel/Code/Python/drapi',
        env = { ['envfile'] = envfile },
        on_exit = vim.schedule_wrap(function(j, return_val)
            print(return_val)
            if (return_val == 2) then return end
            local x = j:result()
            print(vim.inspect(x))
            for _, s in ipairs(x) do
                local p, o = string.find(s, "=")
                local name = (string.sub(s, 0, p - 1))
                local value = (string.sub(s, p + 1))
                vim.env[name] = value
            end
        end)
    }):sync() -- or start()
end

LoadENV()

-- TODO: useful for later
-- function Split(s, delimiter)
--     result = {};
--     for match in (s..delimiter):gmatch("(.-)"..delimiter) do
--         table.insert(result, match);
--     end
--     return result;
-- end
