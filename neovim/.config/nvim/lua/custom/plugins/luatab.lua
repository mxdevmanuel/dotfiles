return {
  'alvarosevilla95/luatab.nvim',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  commands = {
    'tabedit',
    'tabnew',
    'tabNext',
    'tab',
    'tabclose',
    'tabdo',
    'tabfind',
    'tabfirst',
    'tablast',
    'tabmove',
    'tabnext',
    'tabonly',
    'tabprevious',
    'tabrewind',
    'tabs',
  },
  config = function()
    require('luatab').setup()
  end,
}
