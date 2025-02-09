return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
        require('lualine').setup {
            options = {
                icons_enabled = vim.g.have_nerd_font and true or false,
            },
        }
    end,
}
