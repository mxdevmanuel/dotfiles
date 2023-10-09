if !executable('rustfmt')
	finish
end
setlocal formatprg=rustfmt
setlocal makeprg=cargo\ build

setlocal errorformat=
            \%-G,
            \%-Gerror:\ aborting\ %.%#,
            \%-Gerror:\ Could\ not\ compile\ %.%#,
            \%Eerror:\ %m,
            \%Eerror[E%n]:\ %m,
            \%Wwarning:\ %m,
            \%Inote:\ %m,
            \%C\ %#-->\ %f:%l:%c,
            \%E\ \ left:%m,%C\ right:%m\ %f:%l:%c,%Z

" Old errorformat (before nightly 2016/08/10)
setlocal errorformat+=
            \%f:%l:%c:\ %t%*[^:]:\ %m,
            \%f:%l:%c:\ %*\\d:%*\\d\ %t%*[^:]:\ %m,
            \%-G%f:%l\ %s,
            \%-G%*[\ ]^,
            \%-G%*[\ ]^%*[~],
            \%-G%*[\ ]...

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

