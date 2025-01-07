local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local plugins = {
    {"williamboman/mason.nvim"},
    {'williamboman/mason-lspconfig.nvim'},
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate"
    },
    {'tanvirtin/monokai.nvim'},
    {'catppuccin/nvim', name = 'catppuccin'},
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x'
    },
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},

    {'WhoIsSethDaniel/mason-tool-installer.nvim'},
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    kotlin = { "ktlint" },
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>l", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
    },
    {'windwp/nvim-ts-autotag'},
    {'mfussenegger/nvim-jdtls'},
    {'mfussenegger/nvim-dap'},
    {'echasnovski/mini.surround', version = false},
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
}

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins, opts)
