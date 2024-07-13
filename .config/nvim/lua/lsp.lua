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
        "tsserver",
        "rust_analyzer",
        "jdtls",
        "lua_ls",
    },
    handlers = {
        function(gopls)
            require('lspconfig')[gopls].setup({})
        end,
        function(lua_ls)
            require('lspconfig')[lua_ls].setup({})
        end,
    },
})


require("mason-tool-installer").setup({
    ensure_installed = {
      "ktlint",
    }
})
