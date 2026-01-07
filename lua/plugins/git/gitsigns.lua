local wrap_keys = require "utils.wrap_keys"

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufNewFile", "BufReadPost" },
    cmd = { "Gitsigns" },
    opts = { numhl = true },
    keys = wrap_keys {
      { "<leader>gb", ":Gitsigns blame<CR>", desc = "Git Blame" },
      { "<leader>gB", ":Gitsigns blame_line<CR>", desc = "Git Toggle line blame" },
      { "<leader>gD", ':lua require("gitsigns").diffthis("~")<CR>', desc = "Git Diff this" },
      { "<leader>Gd", ':lua require("gitsigns").toggle_deleted()<CR>', desc = "Git deleted diff" },
      { "<leader>gH", ":Gitsigns preview_hunk<CR>", desc = "Git Preview hunk" },
      { "<leader>gh", ":Gitsigns preview_hunk_inline<CR>", desc = "Git Preview hunk inline" },
      {
        "<leader>gL",
        ":Gitsigns toggle_current_line_blame<CR>",
        desc = "Git toggle current line blame",
      },
      { "<leader>gQ", ":Gitsigns setqflist all<CR>", desc = "Git quick fix list All" },
      { "<leader>gq", ":Gitsigns setqflist<CR>", desc = "Git quick fix list" },
      { "<leader>gR", ":Gitsigns reset_buffer<CR>", desc = "Git Reset buffer" },
      { "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Git Reset hunk", mode = { "n", "v" } },
      { "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Git Stage hunk", mode = { "n", "v" } },
      { "<leader>gt", ":Gitsigns toggle_signs<CR>", desc = "Gitsigns toggle" },
      { "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Git Undu hunk" },
      { "[g", ":Gitsigns prev_hunk<CR>", desc = "Git Previous Hunk" },
      { "]g", ":Gitsigns next_hunk<CR>", desc = "Git Next hunk" },
      {
        "ag",
        ':lua require("gitsigns").select_hunk()<CR>',
        desc = "Select hunk",
        mode = { "o", "x" },
      },
      {
        "ig",
        ':lua require("gitsigns").select_hunk()<CR>',
        desc = "Select hunk",
        mode = { "o", "x" },
      },
    },
  },
}
