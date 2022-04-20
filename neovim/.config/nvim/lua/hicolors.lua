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

function h.setup(self)
    local time = tonumber(os.date("%H"))

    if (time < 18 and time > 9) then
        vim.opt.background = 'light'
    else
        vim.opt.background = 'dark'
    end

    if (vim.fn.empty(vim.env.TIMETHEME) == 0 and vim.o.background ~=
        vim.env.TIMETHEME) then vim.o.background = vim.env.TIMETHEME end

    self.gruvbox()
end

return h
