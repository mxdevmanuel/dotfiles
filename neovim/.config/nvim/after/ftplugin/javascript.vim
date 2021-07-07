set shiftwidth=2
if !executable('prettier')
	finish
end
setlocal formatprg=prettier\ --parser\ babel

if exists('$NOAUTOFORMAT')
	finish
end
augroup javascript
	autocmd! BufWritePre <buffer> execute '%!prettier --parser babel'
augroup END
