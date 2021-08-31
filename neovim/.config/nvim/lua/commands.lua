vim.api.nvim_exec([[
	if exists('$TESTCOMMAND')
	  command! Test execute 'new | terminal ' . $TESTCOMMAND . ' ' . expand('%')
	end

	if exists('$SWAYSOCK')
		command! -nargs=0 WriteToClipboard execute 'silent w !wl-copy' | w
	else
		command! -nargs=0 WriteToClipboard execute 'silent w !xclip -selection clipboard -i > /dev/null' | w
	end

	command! Bufonly %bd | e#
	command! IPython new | terminal ipython
	command! -nargs=0 RunPy call OpenTerm('python ' . expand('%'))

	function! DiffWithSaved()
		let filetype=&ft
		diffthis
		vnew | r # | normal! 1Gdd
		diffthis
		exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
	endfunction
	com! DiffSaved call DiffWithSaved()

	augroup Qf
		autocmd!
		autocmd QuickFixCmdPost [^l]* nested cwindow
		autocmd QuickFixCmdPost    l* nested lwindow
	augroup END

	augroup Term
		autocmd!
		autocmd TermOpen * startinsert
		autocmd TermOpen * setlocal listchars= nonumber norelativenumber signcolumn=no
	augroup END

	au! BufRead,BufNewFile .envrc set filetype=sh
	au! TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

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
