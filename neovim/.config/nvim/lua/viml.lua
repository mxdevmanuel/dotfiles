local Job = require 'plenary.job'
local fn = vim.fn

local nvm_extractor = 'extract_nvm.sh'

function SetEnv(name, value) vim.env[name] = value end

function LoadNVM()
    if (fn.executable(nvm_extractor) == 1 and fn.empty(vim.env.NVM_DIR) == 0) then
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

vim.api.nvim_exec([[
	if exists('$TESTCOMMAND')
	  command! Test execute 'new | terminal ' . $TESTCOMMAND . ' ' . expand('%')
	end

	command! Bufonly %bd | e#
	command! IPython new | terminal ipython
	command! -nargs=0 WriteToClipboard execute 'silent w !xclip -selection clipboard -i > /dev/null' | w
	command! -nargs=0 RunPy call OpenTerm('python ' . expand('%'))

	function! DiffWithSaved()
		let filetype=&ft
		diffthis
		vnew | r # | normal! 1Gdd
		diffthis
		exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
	endfunction
	com! DiffSaved call DiffWithSaved()

	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd QuickFixCmdPost    l* nested lwindow

	autocmd TermOpen * startinsert
	autocmd TermOpen * setlocal listchars= nonumber norelativenumber signcolumn=no

	autocmd BufRead,BufNewFile .envrc set filetype=sh

	augroup StatusLineChange
		autocmd!
		 set statusline<
		autocmd BufWinEnter,WinEnter,BufEnter * lua vim.wo.statusline = "%<%#StatusLineGit#%<%{FugitiveStatusline()}%#StatusLineFn# %f %#StatusLine#%h%m%r%=%#StatusLineFt#%y%#StatusLine# %-14.(%l,%c%V%) %P"
		autocmd WinLeave,BufLeave * set statusline<
		autocmd VimResized * redrawstatus
	augroup END

	augroup Packer
	    autocmd!
	    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	  augroup end
]], false)

-- TODO: useful for later
-- function Split(s, delimiter)
--     result = {};
--     for match in (s..delimiter):gmatch("(.-)"..delimiter) do
--         table.insert(result, match);
--     end
--     return result;
-- end
