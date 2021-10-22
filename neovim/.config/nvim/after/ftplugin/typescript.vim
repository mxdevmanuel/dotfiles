set shiftwidth=2
if !executable('prettier')
	finish
end
setlocal formatprg=prettier\ --parser\ typescript

if exists('$NOAUTOFORMAT')
	finish
end

function! Prettier()
	:mark p
	execute '%!prettier --parser typescript'
	:norm g'pzz
endfunction

augroup javascript
	autocmd! BufWritePre <buffer> call Prettier()
augroup END
