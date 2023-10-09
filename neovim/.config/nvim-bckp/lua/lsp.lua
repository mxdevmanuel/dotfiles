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
    { 'n', '<leader>d', vim.diagnostic.setloclist },
    { 'n', '<leader>gd', vim.lsp.buf.definition },
    { 'n', '<leader>i', vim.diagnostic.open_float },
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

M.servers = {
    clangd = {
        config = function(config)
            config.filetypes = { "c", "cpp" }
            return config
        end
    },
    cssls = {},
    -- efm = {
    --     config = function(config)
    --         local eslint = {
    --             lintCommand = 'yarn eslint -f visualstudio --stdin --stdin-filename ${INPUT}',
    --             lintIgnoreExitCode = true,
    --             lintStdin = true,
    --             lintFormats = { "%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m" }
    --         }
    --         local eslintd = {
    --             lintCommand = 'yarn eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
    --             lintSource = 'eslint_d',
    --             lintStdin = true,
    --             lintFormats = { '%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m' },
    --             lintIgnoreExitCode = true
    --             -- formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}',
    --             -- formatStdin = true
    --         }
    --         local flake8 = {
    --             lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
    --             lintStdin = true,
    --             lintFormats = { '%f:%l:%c: %m' }

    --         }
    --         local yamllint = {
    --             lintCommand = 'yamllint -f parsable -',
    --             lintStdin = true
    --         }
    --         local languages = {
    --             javascript = { eslintd },
    --             typescript = { eslintd },
    --             javascriptreact = { eslintd },
    --             typescriptreact = { eslintd },
    --             python = { flake8 },
    --             yaml = { yamllint }
    --         }
    --         config.filetypes = {
    --             "javascript", "javascriptreact", "python", "typescript",
    --             "typescriptreact", "yaml"
    --         }
    --         config.settings = {
    --             rootMarkers = { ".eslintrc", ".eslintrc.js" },
    --             languages = languages,
    --             lintDebounce = '100ms'
    --         }
    --         return config
    --     end
    -- },
    -- pyright = {},
    -- lua_ls = { config = function(config)
    --     config.settings = {
    --         Lua = {
    --             runtime = {
    --                 version = 'LuaJIT'
    --             },
    --             diagnostics = {
    --                 globals = { 'vim', 'use', 'packer_plugins' }
    --             }
    --         }
    --     }
    --     return config;
    -- end },
    -- tailwindcss = {},
    tsserver = {
        config = function(config)
            config.filetypes = {
                "javascript", "javascriptreact", "javascript.jsx", "typescript",
                "typescriptreact", "typescript.tsx"
            };
            return config
        end
    },
    volar = {}
}

function M.install(self)
	local mason = require 'mason'
    mason.setup()
	-- Ensure installed

	-- for name, _ in pairs(self.servers) do
	-- 	local server_is_found, server = lsp_installer.get_server(name)
	-- 	if (server_is_found and not server:is_installed()) then
	-- 		print("Installing " .. name)
	-- 		server:install()
	-- 	end
	-- end
end

function M.setup(self)

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

    local signs = { Error = "", Warn = "", Hint = "", Info = "" }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    local function make_config()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities = require('cmp_nvim_lsp').default_capabilities()
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

    require 'mason'.setup({})

    for name, options in pairs(self.servers) do
        local config = make_config()
        if options.config then config = options.config(config) end
        nvim_lsp[name].setup(config)
    end
end

return M
