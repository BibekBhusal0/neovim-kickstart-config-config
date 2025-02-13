local map = vim.keymap.set

return {
    {
      'ThePrimeagen/vim-be-good',
      config = function()
        map("n", "<leader>zv", "<cmd>VimBeGood<CR>", { desc = "Vim be good" })
      end
    },
    {
      'rktjmp/playtime.nvim',
      config = function()
        map('n', '<leader>zp', '<cmd>Playtime' , {desc = 'More games'})
      end
    },
    {
      'seandewar/nvimesweeper',
      config = function()
        map("n", "<leader>zm", "<cmd>Nvimesweeper <CR>", { desc = "MineSweeper" })
      end
    },
    {
      'jim-fx/sudoku.nvim',
      config = function()
        require("sudoku").setup({
          map("n", "<leader>zs", "<cmd>Sudoku<CR>", { desc = "Sudoku" })
        })
      end
    },
}
