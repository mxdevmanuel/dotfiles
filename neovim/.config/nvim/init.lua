vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.pack.add({
  { src = 'https://github.com/echasnovski/mini.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/tanvirtin/monokai.nvim' },
  { src = 'https://github.com/catgoose/nvim-colorizer.lua' },
  { src = 'https://github.com/NMAC427/guess-indent.nvim' },
})

require('options')
require('keymaps')
require('autocmds')
require('plugins.lsp')
require('plugins.treesitter')
require('plugins.mini')
require('plugins.colorscheme')
