local lsp_zero = require('lsp-zero')


lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('mason-lspconfig').setup({
    ensure_installed = {
        "gopls",
        "ts_ls",
        "rust_analyzer",
        "lua_ls",
        "cssls",
        "html",
        "volar",
        "kotlin_language_server",
        "terraformls",
        "dockerls",
        "bashls",
        "pylsp",
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        function(gopls)
            require('lspconfig')[gopls].setup({})
        end,
        function()
            require('lspconfig').lua_ls.setup({})
        end,
        volar = function()
            require('lspconfig').volar.setup({})
        end,
        ts_ls = function()
            local vue_typescript_plugin = require('mason-registry')
            .get_package('vue-language-server')
            :get_install_path()
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
        function()
            require('lspconfig').terraformls.setup({})
        end,
        function()
            require('pylsp').pylsp.setup({})
        end,


    },
})

require("mason-tool-installer").setup({
    ensure_installed = {
        "ktlint",
    }
})

