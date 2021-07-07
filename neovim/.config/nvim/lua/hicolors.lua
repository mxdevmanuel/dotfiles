local hi = {}

function hi.setup()
    vim.api.nvim_command("highlight CustomGitSignsDelete ctermbg=5 guifg=Red gui=bold")
    vim.api.nvim_command("highlight CustomGitSignsAdd    ctermbg=4 guifg=#6a8f1f gui=bold")
    vim.api.nvim_command("highlight CustomGitSignsChange ctermfg=12 guifg=#FDFD96 gui=bold")
    vim.api.nvim_command("highlight TabLineSel cterm=bold ctermbg=9 guifg=#66d9ef gui=bold")
    vim.api.nvim_command("highlight StatusLineGit ctermbg=5 guifg=#66d9ef gui=bold guibg=#4d5154")
    vim.api.nvim_command("highlight StatusLineFt ctermbg=5 guifg=#FF6188 gui=bold guibg=#4d5154")
    vim.api.nvim_command("highlight StatusLineFn cterm=bold,reverse guifg=#FFF1F3 guibg=#4d5154")
    vim.api.nvim_command("highlight link Title SpecialKey")
end

return hi
