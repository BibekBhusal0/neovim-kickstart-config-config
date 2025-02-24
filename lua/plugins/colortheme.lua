return {
    "bluz71/vim-moonfly-colors",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd [[colorscheme moonfly]]
        vim.api.nvim_set_hl(0, "FoldColumn", { bg = vim.api.nvim_get_hl_by_name('Normal', true).background })
    end,
}
