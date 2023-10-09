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
	silent mark p
	silent %!prettier --stdin-filepath %
	silent 'p
endfunction

augroup javascript
	autocmd! BufWritePre <buffer> call JavascriptFormat()
augroup END
