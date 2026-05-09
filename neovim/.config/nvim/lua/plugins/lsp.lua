require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
  ensure_installed = { 'lua_ls' },
})
require('guess-indent').setup()

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'require' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable('lua_ls')

vim.lsp.config('qmlls', {
  cmd = { '/usr/lib/qt6/bin/qmlls' },
  cmd_env = { QML_IMPORT_PATH = '/usr/lib/qt6/qml' },
  filetypes = { 'qml' },
  root_markers = { '.qmlls.ini', '.git' },
})
vim.lsp.enable('qmlls')
