set shiftwidth=2
if !executable('prettier')
	finish
end
setlocal formatprg=prettier\ --parser\ babel

if exists('$NOAUTOFORMAT')
	finish
end

function! Prettier()
	:mark p
	execute '%!prettier --parser babel'
	:norm g'pzz
endfunction

augroup javascript
	autocmd! BufWritePre <buffer> call Prettier()
augroup END
