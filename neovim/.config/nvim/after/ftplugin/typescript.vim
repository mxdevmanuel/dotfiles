setlocal shiftwidth=2
setlocal tabstop=2
setlocal expandtab

if !executable('prettier')
	finish
end
setlocal formatprg=prettier\ --parser\ typescript

if exists('$NOAUTOFORMAT')
	finish
end

function! TypescriptFormat()
	:mark p
	execute '%!prettier --parser typescript'
	:norm g'pzz
endfunction

augroup typescript
	" autocmd! BufWritePre <buffer> call TypescriptFormat()
	autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting()
augroup END
