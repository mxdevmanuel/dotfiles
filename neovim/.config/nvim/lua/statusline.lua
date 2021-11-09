-- Old statusline
local w = vim.wo
local M = {}

function M.setup()
    w.statusline =
        "%<%#StatusLineGit#%<%{FugitiveStatusline()} %f %#StatusLine#%h%m%r%=%#StatusLineFt# %y %#StatusLine# %-14.(%l,%c%V%) %P"
vim.api.nvim_exec([[
	augroup StatusLineChange
		autocmd!
		 set statusline<
		autocmd BufWinEnter,WinEnter,BufEnter * lua vim.wo.statusline = "%<%#StatusLineGit#%<%{FugitiveStatusline()}%#StatusLineFn# %f %#StatusLine#%h%m%r%=%#StatusLineFt#%y%#StatusLine# %-14.(%l,%c%V%) %P"
		autocmd WinLeave,BufLeave * set statusline<
		autocmd VimResized * redrawstatus
	augroup END
]], false)
end

return M
