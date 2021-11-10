local M = {}
local api = vim.api
local lsp = vim.lsp

M.trunc_width = setmetatable({
    git_status = 90,
    lsp = 90,
    filename = 120
}, {
    __index = function() return 80 end
})

M.is_truncated = function(_, width)
    local current_width = api.nvim_win_get_width(0)
    return current_width < width
end

M.get_git_status = function(self)
    -- use fallback because it doesn't set this variable on the initial `BufEnter`
    local signs = vim.b.gitsigns_status_dict or {
        head = "",
        added = 0,
        changed = 0,
        removed = 0
    }
    local is_head_empty = signs.head ~= ""

    if self:is_truncated(self.trunc_width.git_status) then
        return is_head_empty and string.format("%%<%%#StatusLineGit#  %s ", signs.head or "") or
                   ""
    end

    -- stylua: ignore
    return is_head_empty and
               string.format("%%<%%#StatusLineGit#  %s %%#StatusLineDiff# +%s ~%s -%s ", signs.head, signs.added,
                             signs.changed, signs.removed) or ""
end

function M.get_filename(self)
    local trunc = self:is_truncated(self.trunc_width.filename)
    if trunc then
        return " %t "
    else
        return " %f "
    end
end

function M.get_lsp_diagnostic(self)
    local next = next
    local buf_clients = lsp.buf_get_clients(0)
    if next(buf_clients) == nil then return "" end

    local result = {}
    local levels = {
        errors = 'Error',
        warnings = 'Warning',
        info = 'Information',
        hints = 'Hint'
    }

    for k, level in pairs(levels) do
        result[k] = vim.lsp.diagnostic.get_count(0, level)
    end

    if self:is_truncated(self.trunc_width.lsp) then
        return ''
    else
        return string.format(" %%#StatusLineLspError#:%s %%#StatusLineLspWarning#:%s %%#StatusLineLspInfo#:%s %%#StatusLineLspAction#:%s%%#Statusline# ",
                             result['errors'] or 0, result['warnings'] or 0,
                             result['info'] or 0, result['hints'] or 0)
    end
end

local truncater = "%<"

function M.get_statusline(self)
    return table.concat {
        truncater, self:get_git_status(),
        "%#StatusLine#", self:get_filename(), "%h%m%r", self:get_lsp_diagnostic() ,"%=%#StatusLineFt#",
        "%y", "%#StatusLine#", " %-8.(%l,%c%V%) %P"
    }
end


Statusline = setmetatable(M, {
    __call = function(self) return self:get_statusline(self) end
})

vim.api.nvim_exec([[
	augroup StatusLineChange
		autocmd!
		 set statusline<
		autocmd BufWinEnter,WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline()
		autocmd WinLeave,BufLeave * set statusline<
		autocmd VimResized * redrawstatus
	augroup END
]], false)
