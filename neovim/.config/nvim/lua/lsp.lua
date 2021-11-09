------------------------------
-- Aliases
------------------------------
local fn = vim.fn
------------------------------

local M = {}

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
        local opts = {noremap = true, silent = false}

        bufmap('n', '<C-k>',
                       '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        bufmap('n', '<space>D',
                       '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        bufmap('n', '<space>ca',
                       '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        bufmap('n', '<space>d',
                       '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        bufmap('n', '<space>i',
                       '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                       opts)
        bufmap('n', '<space>gd',
                       '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        bufmap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
                       opts)
        bufmap('n', '<space>wa',
                       '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        bufmap('n', '<space>wl',
                       '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                       opts)
        bufmap('n', '<space>wr',
                       '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                       opts)
        bufmap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)

        bufmap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                       opts)
        bufmap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                       opts)
        -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
                       opts)
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            bufmap("n", "<space>gq",
                           "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end
        if client.resolved_capabilities.document_range_formatting then
            bufmap("v", "<space>gq",
                           "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
            vim.api.nvim_exec([[
		      hi link LspReferenceRead DiffDelete
		      hi link LspReferenceText DiffDelete
		      hi link LspReferenceWrite DiffDelete
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
        if packer_plugins["cmp_nvim_lsp"] and
            packer_plugins["cmp_nvim_lsp"].loaded then
            -- vim.api.nvim_command('PackerLoad lush.nvim')
            print("Loaded cmp")
            capabilities = require('cmp_nvim_lsp').update_capabilities(
                               capabilities)
        end
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
        local eslint = {
            lintCommand = 'yarn eslint -f visualstudio --stdin --stdin-filename ${INPUT}',
            lintIgnoreExitCode = true,
            lintStdin = true,
            lintFormats = {"%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m"}
        }
        local flake8 = {
            lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
            lintStdin = true,
            lintFormats = {'%f:%l:%c: %m'}

        }
        local languages = {
            javascript = {eslint},
            typescript = {eslint},
            javascriptreact = {eslint},
            typescriptreact = {eslint},
            python = {flake8}
        }
        nvim_lsp["efm"].setup({
            filetypes = {
                "javascript", "javascriptreact", "typescript",
                "typescriptreact", "python", "lua"
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
        if server.name == "clangd" then
            config.filetypes = {"c", "cpp"}; -- we don't want objective-c and objective-cpp!
        end
        if server.name == "sumneko_lua" then
            config.settings = {
                Lua = {
                    runtime = {version = 'LuaJIT'},
                    diagnostics = {globals = {'vim', 'use', 'packer_plugins'}}
                }
            }
        end

        server:setup(config)
    end)

end

return M
