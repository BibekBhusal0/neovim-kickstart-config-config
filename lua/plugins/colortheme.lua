return {
    "bluz71/vim-nightfly-colors",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.nightflyNormalFloat = true
        vim.g.nightflyCursorColor = true
        vim.cmd [[colorscheme nightfly]]
    end,
}
