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

    local bg = vim.o.background
    local bghex = bg == 'dark' and colors.dark2.hex or colors.light2.hex
    local gitbg = bg == 'dark' and colors.dark3.hex or colors.light1.hex

    vim.api.nvim_command("highlight StatusLineGit ctermbg=5 guifg=" ..
                             colors.neutral_aqua.hex .. " gui=bold" .. slgui ..
                             " guibg=" .. slcfg)
    vim.api.nvim_command("highlight StatusLineGitAdd ctermbg=5 guifg=" ..
                             colors.bright_green.hex ..
                             " guibg=" .. gitbg)
    vim.api.nvim_command("highlight StatusLineGitChange ctermbg=5 guifg=" ..
                             colors.bright_yellow.hex ..
                             " guibg=" .. gitbg)
    vim.api.nvim_command("highlight StatusLineGitDelete ctermbg=5 guifg=" ..
                             colors.bright_orange.hex ..
                             " guibg=" .. gitbg)
    vim.api.nvim_command("highlight StatusLineFt ctermbg=5 guifg=" ..
                             colors.neutral_purple.hex .. " gui=bold" .. slgui ..
                             " guibg=" .. slcfg)

    vim.api.nvim_command("highlight StatusLineLspError ctermbg=5 guifg=" ..
                             colors.neutral_orange.hex .. " guibg=" ..
                             bghex)
    vim.api.nvim_command("highlight StatusLineLspWarning ctermbg=5 guifg=" ..
                             colors.neutral_yellow.hex .. " guibg=" ..
                             bghex)
    vim.api.nvim_command("highlight StatusLineLspInfo ctermbg=5 guifg=" ..
                             colors.neutral_aqua.hex .. " guibg=" ..
                             bghex)
    vim.api.nvim_command("highlight StatusLineLspAction ctermbg=5 guifg=" ..
                             colors.neutral_green.hex .. " guibg=" ..
                             bghex)
end

function h.setup(self)
    local time = tonumber(os.date("%H"))

    if (time < 18 and time > 9) then
        vim.o.background = 'light'
    else
        vim.o.background = 'dark'
    end

    if (vim.fn.empty(vim.env.TIMETHEME) == 0 and vim.o.background ~=
        vim.env.TIMETHEME) then vim.o.background = vim.env.TIMETHEME end

    self.gruvbox()
end

return h
