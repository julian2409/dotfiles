return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = function()
        require("catppuccin").setup({
            flavour = "mocha",
            no_italic = true, -- Force no italic
        })
        vim.cmd.colorscheme "catppuccin"
    end,
}
