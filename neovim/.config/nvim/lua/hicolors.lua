local namespace = 0

local h = {}

function Highlight(name, val)
    vim.api.nvim_set_hl(namespace, name, val)
end

function h.gruvbox()

    local colors = require('gruvbox.colors')

    vim.api.nvim_command([[ colorscheme gruvbox ]])

    local bg = vim.opt.background:get()

    -- Context colors
    local cc = {
        fadedbg = colors.dark2,
        brightbg = colors.dark3,
        purple = colors.bright_purple,
        aqua = colors.bright_aqua,
        green = colors.bright_green,
        yellow = colors.bright_yellow,
        orange = colors.bright_orange
    }

    if bg == 'light' then
        cc = {
            fadedbg = colors.light2,
            brightbg = colors.light1,
            purple = colors.faded_purple,
            aqua = colors.faded_aqua,
            green = colors.faded_green,
            yellow = colors.faded_yellow,
            orange = colors.faded_orange
        }
    end


    Highlight("StatusLineFt", { fg = cc.purple, bg = cc.fadedbg, bold = 1 })
    Highlight("StatusLineGit", { fg = cc.aqua, bg = cc.brightbg, bold = 1 })
    Highlight("StatusLineGitAdd", { fg = cc.green, bg = cc.brightbg })
    Highlight("StatusLineGitChange", { fg = cc.yellow, bg = cc.brightbg })
    Highlight("StatusLineGitDelete", { fg = cc.orange, bg = cc.brightbg })
    Highlight("StatusLineLspAction", { fg = colors.neutral_green, bg = cc.fadedbg })
    Highlight("StatusLineLspError", { fg = colors.neutral_orange, bg = cc.fadedbg })
    Highlight("StatusLineLspInfo", { fg = colors.neutral_aqua, bg = cc.fadedbg })
    Highlight("StatusLineLspWarning", { fg = colors.neutral_yellow, bg = cc.fadedbg })
end

function h.setDark(self)
    vim.opt.background = 'dark'
    self:setColorscheme()
end

function h.setColorscheme(self)
    self.gruvbox()
end

function h.setup(self)
    local time = tonumber(os.date("%H"))

    if (time < 18 and time > 9) then
        vim.opt.background = 'light'
    else
        vim.opt.background = 'dark'
    end

    if (vim.fn.empty(vim.env.TIMETHEME) == 0 and vim.o.background ~=
        vim.env.TIMETHEME) then vim.opt.background = vim.env.TIMETHEME end

    self:setColorscheme();
end

return h
