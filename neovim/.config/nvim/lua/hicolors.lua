local namespace = 0

local h = {}

function Highlight(name, val)
    vim.api.nvim_set_hl(namespace, name, val)
end

function h.gruvbox()

    local colors = require('gruvbox.colors')

    vim.api.nvim_command([[ colorscheme gruvbox ]])

    local bg = vim.opt.background:get()

    local bghex = bg == 'dark' and colors.dark2 or colors.light2
    local gitbg = bg == 'dark' and colors.dark3 or colors.light1

    Highlight("StatusLineFt", { fg = colors.neutral_purple, bg = bghex , bold = 1})
    Highlight("StatusLineGit", { fg = colors.neutral_aqua, bg = bghex, bold = 1 })
    Highlight("StatusLineGitAdd", { fg = colors.bright_green, bg = gitbg })
    Highlight("StatusLineGitChange", { fg = colors.bright_yellow, bg = gitbg })
    Highlight("StatusLineGitDelete", { fg = colors.bright_orange, bg = gitbg })
    Highlight("StatusLineLspAction", { fg = colors.neutral_green, bg = bghex })
    Highlight("StatusLineLspError", { fg = colors.neutral_orange, bg = bghex })
    Highlight("StatusLineLspInfo", { fg = colors.neutral_aqua, bg = bghex })
    Highlight("StatusLineLspWarning", { fg = colors.neutral_yellow, bg = bghex })
end 


function h.kanagawa(self)
    require'kanagawa'.setup();
    local colors = require('kanagawa.colors')
    local bghex = colors.sumiInk2;
    vim.api.nvim_command("highlight StatusLineGit ctermbg=5 guibg=" ..
                             colors.waveAqua2 .. " gui=bold" .. " guifg=" ..
                             bghex)
    vim.api.nvim_command("highlight StatusLineDiff ctermbg=5 guibg=" ..
                             colors.katanaGray .. " guifg=" .. bghex)
    vim.api.nvim_command("highlight StatusLineFt ctermbg=5 guibg=" ..
                             colors.sakuraPink .. " gui=bold" ..
                             " guifg=" .. bghex)

    vim.api.nvim_command("highlight StatusLineLspError ctermbg=5 guifg=" ..
                             colors.surimiOrange .. " guibg=" .. bghex)
    vim.api.nvim_command("highlight StatusLineLspWarning ctermbg=5 guifg=" ..
                             colors.carpYellow .. " guibg=" .. bghex)
    vim.api.nvim_command("highlight StatusLineLspInfo ctermbg=5 guifg=" ..
                             colors.waveAqua1 .. " guibg=" .. bghex)
    vim.api.nvim_command("highlight StatusLineLspAction ctermbg=5 guifg=" ..
                             colors.autumnGreen .. " guibg=" .. bghex)

    vim.cmd("colorscheme kanagawa")
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
    -- self.kanagawa()
end

return h
