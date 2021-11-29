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

vim.g.did_load_filetypes = 1

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Performance
    use "nathom/filetype.nvim"

    -- File navigation
    use {
        'nvim-telescope/telescope.nvim',
        opt = true,
        cmd = "Telescope",
        module = 'telescope',
        requires = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                opt = true,
                event = "UIEnter",
                run = 'make'
            }, {'nvim-lua/plenary.nvim'}
        },
        config = function() require'others'.telescope() end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        after = 'gitsigns.nvim',
        config = function() require'nvim-tree'.setup {update_cwd = true} end
    }

    -- tbaggery
    use {'tpope/vim-fugitive', opt = true, event = "UIEnter"}
    use {
        'tpope/vim-eunuch',
        opt = true,
        cmd = {
            'Move', 'Delete', 'Mkdir', 'Clocate', 'SudoWrite', 'SudoEdit',
            'Cfind', 'Lfind', 'Llocate', 'Chmod', 'Rename'
        }
    }
    use {'tpope/vim-commentary', opt = true, event = "BufRead"}
    use {'tpope/vim-surround', opt = true, after = "vim-commentary"}
    use {'tpope/vim-repeat', opt = true, after = "vim-surround"}

    -- Colorscheme
    use {
        "mxdevmanuel/gruvbox.nvim",
        requires = {{"rktjmp/lush.nvim", opt = true}},
        opt = true,
        event = "VimEnter",
        config = function() require('hicolors'):setup() end
    }
    -- "savq/melange"

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        opt = true,
        event = "UIEnter",
        branch = "0.5-compat",
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                -- one of "all", "maintained", or a list of languages
                ensure_installed = {
                    "bash", "c", "c_sharp", "clojure", "cmake", "comment",
                    "cpp", "css", "dart", "dockerfile", "dot", "go", "graphql",
                    "html", "java", "javascript", "jsdoc", "json", "json5",
                    "jsonc", "kotlin", "latex", "lua", "php", "python", "r",
                    "regex", "rst", "rust", "scss", "svelte", "toml", "tsx",
                    "turtle", "typescript", "vim", "vue", "yaml"
                },
                sync_install = false,
                highlight = {
                    enable = true -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<leader>+",
                        node_incremental = "<leader>=",
                        node_decremental = "<leader>-",
                        scope_incremental = "<leader>}",
                        scope_decremental = "<leader>{",
                    }
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner"
                        }
                    }
                }
            }

        end
    }
    use {
        'windwp/nvim-ts-autotag',
        after = "nvim-treesitter",
        config = function() require('nvim-ts-autotag').setup() end
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = '0.5-compat',
        after = "nvim-treesitter"
    }

    -- Filetypes
    use 'GutenYe/json5.vim'
    use {'stevearc/vim-arduino', opt = true, ft = 'arduino'}
    use {'chunkhang/vim-mbsync', opt = true, ft = 'mbsync'}

    -- Appeareance
    use {
        'norcalli/nvim-colorizer.lua',
        opt = true,
        event = "InsertEnter",
        config = function() require('colorizer').setup() end
    }
    use { -- It is more complicated making a custom tabline than a statusline, this one's lean
        'alvarosevilla95/luatab.nvim',
        opt = true,
        after = "nvim-tree.lua",
        requires = {{'kyazdani42/nvim-web-devicons', opt = true}},
        config = function() require'luatab'.setup({}) end
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        opt = true,
        event = "InsertEnter",
        config = function()
            require("indent_blankline").setup {
                char = '│',
                filetype_exclude = {'help', 'packer'},
                buftype_exclude = {'terminal', 'nofile'},
                char_highlight = 'LineNr',
                show_trailing_blankline_indent = false,
                -- show_first_indent_level = false,
                use_treesitter = true
            }
        end
    }
    use {
        'rcarriga/nvim-notify',
        opt = true,
        module = 'notify'
    }

    -- Misc
    use {
        'editorconfig/editorconfig-vim',
        opt = true,
        cond = function() return vim.fn.filereadable('.editorconfig') == 1 end
    }
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
    use {'andymass/vim-matchup', opt = true, after = "vim-repeat"}
    use {
        'phaazon/hop.nvim',
        as = 'hop',
        opt = true,
        cmd = "HopChar2",
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
    use {'mbbill/undotree', opt = true, cmd = {'UndotreeToggle'}}

    -- LSP
    use {'williamboman/nvim-lsp-installer', opt = true, event = "VimEnter"}
    use {
        'neovim/nvim-lspconfig',
        after = 'nvim-lsp-installer',
        config = function() require'lsp'.setup() end
    }

    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        event = "UIEnter",
        opt = true,
        requires = {
            {'hrsh7th/cmp-nvim-lsp', module = "cmp_nvim_lsp", opt = true},
            {'hrsh7th/cmp-buffer', opt = true},
            {'hrsh7th/cmp-path', opt = true},
            {'hrsh7th/cmp-nvim-lua', opt = true},
            {'saadparwaiz1/cmp_luasnip', opt = true}
        },
        config = function() require'completion'.setup() end
    }
    use {
        'L3MON4D3/LuaSnip',
        after = "nvim-cmp",
        requires = {{"rafamadriz/friendly-snippets"}},
        config = function() require'completion'.luasnip() end
    }

    -- VCS
    use {
        'lewis6991/gitsigns.nvim',
        opt = true,
        after = "vim-fugitive",
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require'others'.gitsigns() end
    }

    -- Debug
    use {
        'mfussenegger/nvim-dap',
        requires = {{"Pocco81/DAPInstall.nvim", opt = true}},
        opt = true,
        config = function() require'others'.dap() end
    }

end)
