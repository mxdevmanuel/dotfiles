if !executable('rustfmt')
	finish
end
setlocal formatprg=rustfmt
setlocal makeprg=cargo\ build

if exists('$AUTOFORMAT')
	function! RustFmt()
		:mark p
		execute '%!prettier --parser babel'
		:norm g'pzz
	endfunction

	augroup javascript
		autocmd! BufWritePre <buffer> call RustFmt()
	augroup END
end

