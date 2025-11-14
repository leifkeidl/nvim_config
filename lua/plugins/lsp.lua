return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },

    config = function()
        ---------------------------------------------------------------------
        -- FORMAT-ON-SAVE FILETYPES
        ---------------------------------------------------------------------
        local autoformat_filetypes = {
            "lua",
            "c", "cpp",
            "javascript", "typescript",
            "javascriptreact", "typescriptreact",
            "python",
        }

        ---------------------------------------------------------------------
        -- FORMAT ON SAVE
        ---------------------------------------------------------------------
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end
                if vim.tbl_contains(autoformat_filetypes, vim.bo.filetype) then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({
                                formatting_options = { tabSize = 4, insertSpaces = true },
                                bufnr = args.buf,
                                id = client.id,
                            })
                        end
                    })
                end
            end
        })

        ---------------------------------------------------------------------
        -- UI / DIAGNOSTICS
        ---------------------------------------------------------------------
        vim.lsp.handlers['textDocument/hover'] =
            vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
        vim.lsp.handlers['textDocument/signatureHelp'] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN]  = '▲',
                    [vim.diagnostic.severity.HINT]  = '⚑',
                    [vim.diagnostic.severity.INFO]  = '»',
                },
            },
        })

        ---------------------------------------------------------------------
        -- CMP CAPABILITIES
        ---------------------------------------------------------------------
        local lspconfig_defaults = require('lspconfig').util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        ---------------------------------------------------------------------
        -- KEYMAPS ON LSP ATTACH
        ---------------------------------------------------------------------
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)

                vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>',
                    function() vim.lsp.buf.format({ async = true }) end,
                    opts)
                vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
            end,
        })

        ---------------------------------------------------------------------
        -- MASON + SERVER SETUP
        ---------------------------------------------------------------------
        require('mason').setup({})

        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls",
                "clangd",        -- C / C++
                "intelephense",  -- PHP
                "ts_ls",         -- JS/TS/React
                "eslint",
                "pyright",       -- Python
                "rust_analyzer", -- Rust
            },

            handlers = {
                -- Default handler
                function(server_name)
                    -- skip: we handle lua_ls manually
                    if server_name == "lua_ls" then return end
                    require("lspconfig")[server_name].setup({})
                end,

                -----------------------------------------------------------------
                -- LUA SETUP (corrected from your broken "luals")
                -----------------------------------------------------------------
                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                diagnostics = { globals = { 'vim' } },
                                workspace = {
                                    library = { vim.env.VIMRUNTIME },
                                },
                            },
                        },
                    })
                end,
            },
        })

        ---------------------------------------------------------------------
        -- CMP COMPLETION ENGINE
        ---------------------------------------------------------------------
        local cmp = require('cmp')
        require('luasnip.loaders.from_vscode').lazy_load()
        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = { completeopt = 'menu,menuone,noinsert' },
            window = { documentation = cmp.config.window.bordered() },

            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer',  keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },

            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },

            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    item.menu = ({
                        nvim_lsp = '[LSP]',
                        nvim_lua = '[Lua]',
                        buffer   = '[Buf]',
                        path     = '[Path]',
                        luasnip  = '[Snip]',
                    })[entry.source.name] or ('[' .. entry.source.name .. ']')
                    return item
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-f>'] = cmp.mapping.scroll_docs(5),
                ['<C-u>'] = cmp.mapping.scroll_docs(-5),

                ['<C-e>'] = cmp.mapping(function()
                    if cmp.visible() then cmp.abort() else cmp.complete() end
                end),

                ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),

                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),

                -- Snippet jumps
                ['<C-d>'] = cmp.mapping(function(fallback)
                    if require('luasnip').jumpable(1) then
                        require('luasnip').jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<C-b>'] = cmp.mapping(function(fallback)
                    if require('luasnip').jumpable(-1) then
                        require('luasnip').jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
        })
    end
}
