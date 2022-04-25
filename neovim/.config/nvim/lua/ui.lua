local statusline = require('statusline')

Statusline = setmetatable(statusline, {
    __call = function(self) return self:get_statusline(self) end
})

local statusline_group_id = vim.api.nvim_create_augroup("StatusLineChange", {})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "BufEnter" }, {
    group = statusline_group_id,
    pattern = "*",
    command = "setlocal statusline=%!v:lua.Statusline()"
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = statusline_group_id,
    pattern = "*",
    command = "set statusline<"
})
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = statusline_group_id,
    pattern = "*",
    command = "redrawstatus"
})
