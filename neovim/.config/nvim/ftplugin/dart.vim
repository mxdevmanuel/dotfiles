if executable("dart")
  set formatprg=dart\ format
endif

if executable("flutter")
  " autocmd BufWritePre *.dart !flutter format %
  autocmd BufWritePre *.dart :lua vim.lsp.buf.formatting()
endif

