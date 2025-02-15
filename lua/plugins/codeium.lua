return {
    'Exafunction/codeium.vim',
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    event = 'BufEnter',
    config = function()
        vim.keymap.set('n', '<leader>cc', '<cmd>Codeium Toggle<CR>', { noremap = true, silent = true })
    end
}
-- FIX: Not working don't know why
