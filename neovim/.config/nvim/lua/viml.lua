vim.api.nvim_exec([[
	command! Sw execute 'silent w !sudo tee % >/dev/null' | edit!

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
]], false)

