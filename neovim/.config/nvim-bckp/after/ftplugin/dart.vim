setlocal shiftwidth=2
setlocal tabstop=2
setlocal expandtab

if executable("dart")
  setlocal formatprg=dart\ format
endif

if executable("flutter")
  " autocmd BufWritePre *.dart !flutter format %
  autocmd BufWritePre *.dart :lua vim.lsp.buf.formatting()
endif

