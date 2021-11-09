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
    use("nathom/filetype.nvim")

    -- Fuzzy search
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use {
        'nvim-telescope/telescope.nvim',
        opt = true,
        event = "VimEnter",
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
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
                incremental_selection = {enable = true}
            }

        end
    }

    -- Filetypes
    use 'GutenYe/json5.vim'
    use {'stevearc/vim-arduino', opt = true, ft = 'arduino'}
    use {'chunkhang/vim-mbsync', opt = true, ft = 'mbsync'}

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
        after = "nvim-tree.lua",
        requires = {
            {
                'kyazdani42/nvim-web-devicons',
                opt = true,
                after = "nvim-tree.lua"
            }
        },
        config = function()
		require'luatab'.setup({})
        end
    }

    -- Misc
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        after = 'gitsigns.nvim',
        config = function() require'nvim-tree'.setup {update_cwd = true} end
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
    use {
        'windwp/nvim-ts-autotag',
        after = "nvim-treesitter",
        config = function() require('nvim-ts-autotag').setup() end
    }
    use {'andymass/vim-matchup', opt = true, event = "InsertEnter"}
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
    use {'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu'}

    -- Completion
    use {"rafamadriz/friendly-snippets", event = "InsertEnter"}
    use {
        'hrsh7th/nvim-cmp',
        after = "friendly-snippets",
        config = function() require'completion'.setup() end
    }
    use {
        'L3MON4D3/LuaSnip',
        after = "nvim-cmp",
        wants = "friendly-snippets",
        config = function() require'completion'.luasnip() end
    }
    use {'saadparwaiz1/cmp_luasnip', after = "LuaSnip"}
    use {'hrsh7th/cmp-nvim-lsp', after = "cmp_luasnip"}
    use {'hrsh7th/cmp-buffer', after = "cmp-nvim-lsp"}
    use {"hrsh7th/cmp-path", after = "cmp-buffer"}

    -- VCS
    use {
        'lewis6991/gitsigns.nvim',
        opt = true,
        event = "VimEnter",
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require'others'.gitsigns() end
    }

    -- Debug
    use {
        'mfussenegger/nvim-dap',
        opt = true,
        config = function() require'others'.dap() end
    }

end)
