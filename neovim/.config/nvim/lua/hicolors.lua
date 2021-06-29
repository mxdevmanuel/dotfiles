local hi = {}

function hi.setup()
    vim.api.nvim_command("highlight CustomGitSignsDelete ctermbg=5 guifg=Red gui=bold")
    vim.api.nvim_command("highlight CustomGitSignsAdd    ctermbg=4 guifg=#6a8f1f gui=bold")
    vim.api.nvim_command("highlight CustomGitSignsChange ctermfg=12 guifg=#FDFD96 gui=bold")
    vim.api.nvim_command("highlight TabLineSel cterm=bold ctermbg=9 guifg=#000000 guibg=#66d9ef")
    vim.api.nvim_command("highlight link Title SpecialKey")
end

return hi
