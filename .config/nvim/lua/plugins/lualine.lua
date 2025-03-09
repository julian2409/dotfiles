return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
        require('lualine').setup {
            options = {
                icons_enabled = jit.os ~= "OSX" and true or false,
            },
        }
    end,
}
