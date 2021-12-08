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
	silent mark p
	silent %!prettier --parser typescript
	silent 'p
endfunction

augroup typescript
	autocmd! BufWritePre <buffer> call TypescriptFormat()
augroup END
