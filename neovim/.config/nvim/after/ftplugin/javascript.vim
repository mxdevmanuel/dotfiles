setlocal shiftwidth=2
setlocal tabstop=2
setlocal expandtab

if !executable('prettier')
	finish
end
setlocal formatprg=prettier\ --parser\ babel

if exists('$NOAUTOFORMAT')
	finish
end

function! JavascriptFormat()
	:mark p
	execute '%!prettier --parser babel'
	:norm g'pzz
endfunction

augroup javascript
	autocmd! BufWritePre <buffer> call JavascriptFormat()
augroup END
