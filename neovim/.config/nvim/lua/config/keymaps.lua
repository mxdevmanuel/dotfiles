-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if vim.fn.maparg("<C-L>", "c") == "" then
  vim.api.nvim_set_keymap("c", "<C-L>", '<C-R>=expand("%:p:h") . "/"<CR>', {
    noremap = true,
  })
end
