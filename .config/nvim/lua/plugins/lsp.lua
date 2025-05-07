return {
    {
        'mason-org/mason.nvim',
        opts = {},
    },
    {
        'williamboman/mason-lspconfig.nvim',
        -- Need upgrade to nvim 0.11 for v2
        version = "^1",
        opts = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'bashls',
                    'clangd',
                    'cssls',
                    'dockerls',
                    'emmet_language_server',
                    'gopls',
                    'groovyls',
                    'html',
                    'kotlin_language_server',
                    'lua_ls',
                    'pylsp',
                    'terraformls',
                    'ts_ls',
                    'volar',
                    'yamlls',
                },
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,

                    emmet_language_server = function()
                        require('lspconfig').emmet_language_server.setup({
                            filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact", "vue", },
                        })
                    end,

                    ts_ls = function()
                        -- TODO: get mason packages location dynamically
                        local vue_typescript_plugin = '/home/jsa/.local/share/nvim/mason/packages/'
                            .. '/vue-language-server'
                            .. '/node_modules/@vue/language-server'
                            .. '/node_modules/@vue/typescript-plugin'

                        require('lspconfig').ts_ls.setup({
                            init_options = {
                                plugins = {
                                    {
                                        name = "@vue/typescript-plugin",
                                        location = vue_typescript_plugin,
                                        languages = {'javascript', 'typescript', 'vue'}
                                    },
                                }
                            },
                            filetypes = {
                                'javascript',
                                'javascriptreact',
                                'javascript.jsx',
                                'typescript',
                                'typescriptreact',
                                'typescript.tsx',
                                'vue',
                            },
                        })
                    end,
                }
            })
        end,
    },
    { 'neovim/nvim-lspconfig' },
    {
        'hrsh7th/cmp-nvim-lsp',
        opts = function()
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            local lspconfig_defaults = require('lspconfig').util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
            )

            -- This is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = {buffer = event.buf}

                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                end,
            })
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        opts = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    {name = 'nvim_lsp'},
                },
                snippet = {
                    expand = function(args)
                        -- You need Neovim v0.10 to use vim.snippet
                        vim.snippet.expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({}),
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        -- install jsregexp (optional!).
        -- build = "make install_jsregexp",
        -- opts = {},
    },
}
