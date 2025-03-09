return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "c",
                "lua",
                "vimdoc",
                "javascript",
                "typescript",
                "go",
                "java",
                "kotlin",
                "css",
                "scss",
                "html",
                "dockerfile",
                "yaml",
                "bash",
                "python",
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

        })
    end,
}
