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
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'}
        }
    }

    -- tbaggery
    use {'tpope/vim-fugitive', opt = true, event = "VimEnter"}
    use {
        'tpope/vim-eunuch',
        opt = true,
        cmd = {
            'Move', 'Delete', 'Mkdir', 'Clocate', 'SudoWrite', 'SudoEdit',
            'Cfind', 'Lfind', 'Llocate', 'Chmod', 'Rename'
        }
    }
    use {'tpope/vim-commentary', opt = true, event = "BufRead"}
    use {'tpope/vim-surround', opt = true, event = "BufRead"}
    use {'tpope/vim-repeat', opt = true, event = "BufRead"}

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
	branch = "0.5-compat",
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                -- one of "all", "maintained", or a list of languages
                ensure_installed = "maintained",
                -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
                highlight = {
                    enable = true -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                },
                incremental_selection = {enable = true}
            }

        end
    }

    -- Filetypes
    use 'GutenYe/json5.vim'
    use {'stevearc/vim-arduino', opt=true, ft='arduino'}

    -- Appeareance
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
    use{  'glepnir/dashboard-nvim', opt = true, event = "VimEnter" }
    use {
        'mattn/emmet-vim',
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
    use {'kabouzeid/nvim-lspinstall', opt = true, event = "VimEnter"}
    use {'hrsh7th/nvim-compe', opt = true, after = "nvim-lspinstall"}
    use {
        'neovim/nvim-lspconfig',
        opt = true,
        after = 'nvim-compe',
        config = function() require'lsp'.setup() end
    }
    use {
        'tzachar/compe-tabnine',
        run = './install.sh',
        requires = 'hrsh7th/nvim-compe',
        after = 'nvim-compe',
        opt = true
    }
    use {'glepnir/lspsaga.nvim', opt = true, after = "nvim-lspconfig"}

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
