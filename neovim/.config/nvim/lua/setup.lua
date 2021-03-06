require'nvim-treesitter.configs'.setup {
    -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
    highlight = {
        enable = true -- false will disable the whole extension
        -- disable = { "c", "rust" },  -- list of language that will be disabled
    }
}

require('colorizer').setup()

require('gitsigns').setup({
    signs = {
        add = {
            -- hl = 'CustomGitSignsAdd',
	    hl = 'GitSignsAdd',
            text = '+',
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn'
        },
        change = {
            -- hl = 'CustomGitSignsChange',
            hl = 'GitSignsChange',
            text = '•',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        },
        delete = {
            -- hl = 'CustomGitSignsDelete',
            hl = 'GitSignsDelete',
            text = '-',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        topdelete = {
            -- hl = 'CustomGitSignsDelete',
            hl = 'GitSignsDelete',
            text = '‾',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        changedelete = {
            -- hl = 'CustomGitSignsDelete',
            hl = 'GitSignsChange',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        }
    },
    numhl = false
})

require('nvim-autopairs').setup({check_ts = true})
