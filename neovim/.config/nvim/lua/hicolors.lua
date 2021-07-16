local h = {}

function h.gruvbox(self)
    if packer_plugins["lush.nvim"] and not packer_plugins["lush.nvim"].loaded then
        vim.api.nvim_command('PackerLoad lush.nvim')
    end

    local colors = require('gruvbox.colors')
    local base = require('gruvbox.base')

    vim.api.nvim_command([[ colorscheme gruvbox ]])

    local slgui = ""
    if (base.StatusLine.gui) then slgui = "," .. base.StatusLine.gui end
    local slcfg = base.StatusLine.bg.hex
    if (vim.o.background == 'light') then slcfg = colors.light1.hex end
    vim.api.nvim_command("highlight StatusLineGit ctermbg=5 guifg=" ..
                             colors.faded_aqua.hex .. " gui=bold" .. slgui ..
                             " guibg=" .. slcfg)
    vim.api.nvim_command("highlight StatusLineFt ctermbg=5 guifg=" ..
                             colors.neutral_purple.hex .. " gui=bold" .. slgui ..
                             " guibg=" .. slcfg)
end

function h.setup(self)
    time = tonumber(os.date("%H"))

    if (time < 19 and time > 9) then
        vim.o.background = 'light'
    else
        vim.o.background = 'dark'
    end

    if (vim.o.background ~= vim.env.TIMETHEME) then
	    vim.o.background = vim.env.TIMETHEME
    end

    self.gruvbox()
end

return h
