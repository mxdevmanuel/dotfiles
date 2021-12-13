------------------------------
-- Aliases
------------------------------
local fn = vim.fn
------------------------------

local M = {}

M.mappings = {
    {'n', '<F8>', '<cmd>Telescope diagnostics<CR>'},
    {'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>'},
    {'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>'},
    {'n', '<leader>ca', '<cmd>Telescope lsp_code_actions<CR>'},
    {'n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'},
    {'n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>'}, --
    {
        'n', '<leader>i',
        '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'
    }, {'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>'}, --
    {'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'}, --
    {'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'}, --
    {'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>'},
    {'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
    {'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
    {'n', 'gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>'},
    {'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>'},
    {'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>'}
}

local opts = {
    noremap = true,
    silent = false
}

function M.setup()

    -- On attach function for LSP clients
    local on_attach = function(client, bufnr)
        local function bufmap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function bufopt(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        bufopt('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.

        for i, v in ipairs(M.mappings) do bufmap(v[1], v[2], v[3], opts) end

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            bufmap("n", "gQ", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end
        if client.resolved_capabilities.document_range_formatting then
            bufmap("v", "gq", "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
                   opts)
        end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
            vim.api.nvim_exec([[
		      augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		      augroup END ]], false)
        end
    end

    local function make_config()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport =
            true
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
        return {
            -- enable snippet support
            capabilities = capabilities,
            -- map buffer local keybindings when the language server attaches
            on_attach = on_attach
        }
    end

    -- Setup lsp

    local nvim_lsp = require('lspconfig')

    if fn.executable("flutter") == 1 then
        local config = make_config()
        nvim_lsp["dartls"].setup(config)
    end

    if fn.executable("efm-langserver") == 1 then
        local _eslint = {
            lintCommand = 'yarn eslint -f visualstudio --stdin --stdin-filename ${INPUT}',
            lintIgnoreExitCode = true,
            lintStdin = true,
            lintFormats = {"%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m"}
        }
        local eslint = {
            lintCommand = 'yarn eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
            lintSource = 'eslint_d',
            lintStdin = true,
            lintFormats = {'%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m'},
            lintIgnoreExitCode = true
            -- formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}',
            -- formatStdin = true
        }
        local flake8 = {
            lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
            lintStdin = true,
            lintFormats = {'%f:%l:%c: %m'}

        }
        local yamllint = {
            lintCommand = 'yamllint -f parsable -',
            lintStdin = true
        }
        local languages = {
            javascript = {eslint},
            typescript = {eslint},
            javascriptreact = {eslint},
            typescriptreact = {eslint},
            python = {flake8},
            yaml = {yamllint}
        }
        nvim_lsp["efm"].setup({
            filetypes = {
                "javascript", "javascriptreact", "python", "typescript",
                "typescriptreact", "yaml"
            },
            settings = {
                rootMarkers = {".eslintrc", ".eslintrc.js"},
                languages = languages,
                lintDebounce = '100ms'
            }
        })
    end

    local lsp_installer = require 'nvim-lsp-installer'

    lsp_installer.on_server_ready(function(server)
        local config = make_config()

        -- language specific config
        if server.name == "tsserver" then
            config.filetypes = {
                "javascript", "javascriptreact", "javascript.jsx", "typescript",
                "typescriptreact", "typescript.tsx"
            };
        end
        if server.name == "clangd" then config.filetypes = {"c", "cpp"}; end
        if server.name == "sumneko_lua" then
            config.settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT'
                    },
                    diagnostics = {
                        globals = {'vim', 'use', 'packer_plugins'}
                    }
                }
            }
        end

        server:setup(config)
    end)

end

return M
