local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    execute 'packadd packer.nvim'
end

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Fuzzy search
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- tbaggery
    use 'tpope/vim-commentary'
    use {
        'tpope/vim-eunuch',
        opt = true,
        cmd = {
            'Move', 'Delete', 'Mkdir', 'Clocate', 'SudoWrite', 'SudoEdit',
            'Cfind', 'Lfind', 'Llocate'
        }
    }
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'

    -- Colorscheme
    use {
        "npxbr/gruvbox.nvim",
        requires = {{"rktjmp/lush.nvim", opt = true}},
        opt = true,
        event = "VimEnter",
        config = function() require('hicolors'):setup() end
    }

    -- Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- Appeareance
    use {
        "lukas-reineke/indent-blankline.nvim",
        opt = true,
        ft = {
            'html', 'javascriptreact', 'typescriptreact', 'htmldjango', 'xml',
            'json'
        },
        config = function()
            vim.g.indent_blankline_char = "┆"
            vim.g.indent_blankline_filetype_exclude = {
                "help", "defx", "vimwiki", "man", "gitmessengerpopup",
                "diagnosticpopup"
            }
            vim.g.indent_blankline_buftype_exclude = {"terminal"}
            vim.g.indent_blankline_space_char_blankline = " "
            vim.g.indent_blankline_strict_tabs = true
            -- vim.g.indent_blankline_debug = true
            vim.g.indent_blankline_show_current_context = true
            vim.g.indent_blankline_context_patterns = {
                "class", "function", "method", "^if", "while", "for", "with",
                "func_literal", "block", "try", "except", "argument_list",
                "object", "dictionary"
            }
        end
    }
    use 'norcalli/nvim-colorizer.lua'

    -- Magic
    use 'mhinz/vim-startify'
    use {
        'mattn/emmet-vim',
        event = 'InsertEnter',
        ft = {
            'html', 'css', 'javascript', 'javascriptreact', 'vue', 'typescript',
            'typescriptreact'
        }
    }
    use 'windwp/nvim-autopairs'
    use 'andymass/vim-matchup'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'
    use {
        'tzachar/compe-tabnine',
        run = './install.sh',
        requires = 'hrsh7th/nvim-compe'
    }
    use 'kabouzeid/nvim-lspinstall'
    use 'glepnir/lspsaga.nvim'

    -- VCS
    use 'junegunn/gv.vim'
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

end)
