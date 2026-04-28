-- nvim-treesitter 1.x: stripped-down parser installer only.
-- Highlighting/indent/selection are handled natively by Neovim 0.12+ treesitter.
require('nvim-treesitter').setup()

-- Auto-install parser for the current filetype when it opens.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ts-auto-install', { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then return end
    local ok = pcall(vim.treesitter.language.inspect, lang)
    if not ok then
      pcall(require('nvim-treesitter').install, { lang })
    end
  end,
})
