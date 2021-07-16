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
    use {
        'nvim-telescope/telescope.nvim',
        opt = true,
        event = "VimEnter",
        requires = {
            {'nvim-lua/popup.nvim', event = "VimEnter"},
            {'nvim-lua/plenary.nvim'}
        }
    }

    -- tbaggery
    use 'tpope/vim-commentary'
    use {
        'tpope/vim-eunuch',
        opt = true,
        cmd = {
            'Move', 'Delete', 'Mkdir', 'Clocate', 'SudoWrite', 'SudoEdit',
            'Cfind', 'Lfind', 'Llocate', 'Chmod', 'Rename'
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
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
                highlight = {
                    enable = true -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                }
            }

        end
    }

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
    use {
        'norcalli/nvim-colorizer.lua',
        opt = true,
        event = "VimEnter",
        config = function() require('colorizer').setup() end
    }
    use { -- It is more complicated making a custom tabline than a statusline, this one's lean
        'alvarosevilla95/luatab.nvim',
        opt = true,
        event = "VimEnter",
        requires = {
            {'kyazdani42/nvim-web-devicons', opt = true, event = "VimEnter"}
        },
        config = function()
            vim.o.tabline = '%!v:lua.require\'luatab\'.tabline()'
        end
    }

    -- Misc
    use 'nvim-lua/plenary.nvim'
    use 'mhinz/vim-startify'
    use {
        'mattn/emmet-vim',
        event = 'InsertEnter',
        ft = {
            'html', 'css', 'javascript', 'javascriptreact', 'vue', 'typescript',
            'typescriptreact'
        }
    }
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({check_ts = true})
        end
    }
    use {'andymass/vim-matchup', opt = true, event = "VimEnter"}
    use {
        'phaazon/hop.nvim',
        as = 'hop',
        opt = true,
        event = "VimEnter",
        config = function()
            require'hop'.setup {keys = 'etovxqpdygfblzhckisuran'}
        end
    }
    use {
        'folke/which-key.nvim',
        opt = true,
        cmd = {'WhichKey'},
        config = function() require'which-key'.setup() end
    }

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
    use {'junegunn/gv.vim', opt = true, cmd = {'GV'}}
    use {
        'lewis6991/gitsigns.nvim',
        opt = true,
        event = "VimEnter",
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            if packer_plugins["plenary.nvim"] and
                not packer_plugins["plenary.nvim"].loaded then
                vim.api.nvim_command('PackerLoad plenary.nvim')
            end
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
        end
    }

    -- Debug
    use {
        'mfussenegger/nvim-dap',
        opt = true,
        config = function()
            local dap = require('dap')
            dap.adapters.python = {
                type = 'executable',
                command = os.getenv('VIRTUAL_ENV') .. '/bin/python',
                args = {'-m', 'debugpy.adapter'}
            }
        end
    }
end)
