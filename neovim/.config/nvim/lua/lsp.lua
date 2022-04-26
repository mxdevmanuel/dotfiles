------------------------------
-- Aliases
------------------------------
local fn = vim.fn
------------------------------

local M = {}


M.mappings = {
    { 'n', '<F8>', function() require 'telescope'.builtin.diagnostics() end },
    { 'n', '<C-k>', vim.lsp.buf.signature_help },
    { 'n', '<leader>D', vim.lsp.buf.type_definition },
    { 'n', '<leader>ca', function() require 'telescope'.builtin.lsp_code_actions() end },
    { 'n', '<leader>d', vim.lsp.diagnostic.set_loclist },
    { 'n', '<leader>gd', vim.lsp.buf.definition },
    { 'n', '<leader>i', vim.lsp.diagnostic.show_line_diagnostics },
    { 'n', '<leader>rn', vim.lsp.buf.rename },
    { 'n', '<leader>wa', vim.lsp.buf.add_workspace_folder },
    { 'n', '<leader>wr', vim.lsp.buf.remove_workspace_folder },
    { 'n', 'K', vim.lsp.buf.hover },
    { 'n', '[d', vim.diagnostic.goto_prev },
    { 'n', ']d', vim.diagnostic.goto_next },
    { 'n', 'gd', vim.lsp.buf.declaration },
    { 'n', 'gi', vim.lsp.buf.implementation },
    { 'n', 'gr', vim.lsp.buf.references }
}

function M.setup()

    -- On attach function for LSP clients
    local on_attach = function(client, bufnr)

        local function bufmap(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr })
        end

        local function bufopt(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        bufopt('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.

        for _, v in ipairs(M.mappings) do bufmap(v[1], v[2], v[3]) end

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            bufmap("n", "gQ", vim.lsp.buf.formatting)
        end
        if client.resolved_capabilities.document_range_formatting then
            bufmap("v", "gq", vim.lsp.buf.range_formatting)
        end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
            local lsp_document_highlight_gid = vim.api.nvim_create_augroup("LspDocumentHighlight", {})

            vim.api.nvim_create_autocmd({ "CursorHold" }, {
                group = lsp_document_highlight_gid,
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight
            })
            vim.api.nvim_create_autocmd({ "CursorMoved " }, {
                group = lsp_document_highlight_gid,
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references
            })
        end
    end

    local function make_config()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
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
        -- local config = make_config()
        -- nvim_lsp["dartls"].setup(config)
        require('flutter-tools').setup({})
    end

    if fn.executable("efm-langserver") == 1 then
        local _eslint = {
            lintCommand = 'yarn eslint -f visualstudio --stdin --stdin-filename ${INPUT}',
            lintIgnoreExitCode = true,
            lintStdin = true,
            lintFormats = { "%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m" }
        }
        local eslint = {
            lintCommand = 'yarn eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
            lintSource = 'eslint_d',
            lintStdin = true,
            lintFormats = { '%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m' },
            lintIgnoreExitCode = true
            -- formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}',
            -- formatStdin = true
        }
        local flake8 = {
            lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
            lintStdin = true,
            lintFormats = { '%f:%l:%c: %m' }

        }
        local yamllint = {
            lintCommand = 'yamllint -f parsable -',
            lintStdin = true
        }
        local languages = {
            javascript = { eslint },
            typescript = { eslint },
            javascriptreact = { eslint },
            typescriptreact = { eslint },
            python = { flake8 },
            yaml = { yamllint }
        }
        nvim_lsp["efm"].setup({
            filetypes = {
                "javascript", "javascriptreact", "python", "typescript",
                "typescriptreact", "yaml"
            },
            settings = {
                rootMarkers = { ".eslintrc", ".eslintrc.js" },
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
        if server.name == "clangd" then config.filetypes = { "c", "cpp" }; end
        if server.name == "sumneko_lua" then
            config.settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT'
                    },
                    diagnostics = {
                        globals = { 'vim', 'use', 'packer_plugins' }
                    }
                }
            }
        end

        server:setup(config)
    end)

end

return M
