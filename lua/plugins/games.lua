return {
    {
        "ThePrimeagen/vim-be-good",
        lazy = true,
        cmd = { 'VimBeGood' },
        keys = {
            { "<leader>zv", "<cmd>VimBeGood<CR>", desc = "Vim be good" }
        }
    },
    {
        "rktjmp/playtime.nvim",
        lazy = true,
        cmd = { 'Playtime' },
        keys = {
            { "<leader>zp", "<cmd>Playtime<CR>", desc = "More games" }
        }
    },
    {
        "seandewar/nvimesweeper",
        lazy = true,
        cmd = { 'Nvimesweeper' },
        keys = {
            { "<leader>zm", "<cmd>Nvimesweeper <CR>", desc = "MineSweeper" }
        }
    },
    {
        "jim-fx/sudoku.nvim",
        lazy = true,
        cmd = { 'Sudoku' },
        keys = {
            { "<leader>zs", "<cmd>Sudoku<CR>", desc = "Sudoku" }
        },
        opts = {}
    },
}
