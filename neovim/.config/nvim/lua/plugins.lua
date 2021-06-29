local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Fuzzy search
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- tbaggery
  use 'tpope/vim-commentary'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  -- Colorscheme
  use {  'tanvirtin/monokai.nvim', config =  "require'hicolors'.setup()" }

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Appeareance
  use 'Yggdroot/indentLine'
  use 'norcalli/nvim-colorizer.lua'

  -- Magic
  use 'mhinz/vim-startify'
  use 'mattn/emmet-vim'
  use 'windwp/nvim-autopairs'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  use {'tzachar/compe-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-compe'}
  use 'kabouzeid/nvim-lspinstall'

  -- VCS
  use 'junegunn/gv.vim'
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

end)
