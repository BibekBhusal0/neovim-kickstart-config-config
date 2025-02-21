map = require('utils.map')
input = require('utils.input')
local function commit_with_message()
    input(" Commit Message ", function(text) vim.cmd("Git commit -m '" .. text .. "'") end, '', 40)
end

local function commit_all_with_message()
    input(" Commit Message ", function(text)
        vim.cmd("Git commit -a -m '" .. text .. "'")
    end, '', 50)
end

map("<leader>gp", "<cmd>Git push<CR>", "Git push")
map("<leader>ga", "<cmd>Git add .<CR>", "Git add all files")
map("<leader>gi", "<cmd>Git init<CR>", "Git Init")
map("<leader>gA", "<cmd>Git add %<CR>", "Git add current file")
map("<leader>gP", "<cmd>Git pull<CR>", "Git pull")
map("<leader>gC", commit_with_message, "Git commit")
map("<leader>gc", commit_all_with_message, "Git commit all")

map("]g", "<cmd>Gitsigns next_hunk<CR>zz", "Git Next change")
map("[g", "<cmd>Gitsigns prev_hunk<CR>zz", "Git Previous change")
map("<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", "Git Stage hunk")
map("<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", "Git Reset hunk")
map("<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", "Git Stage buffer")
map("<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", "Git Reset buffer")
map("<leader>gh", "<cmd>Gitsigns preview_hunk<CR>", "Git Preview hunk")
map("<leader>gH", "<cmd>Gitsigns preview_hunk_inline<CR>", "Git Preview hunk inline")
map("<leader>gb", "<cmd>Gitsigns blame<CR>", "Git Blame")
map("<leader>gB", "<cmd>Gitsigns blame_line<CR>", "Git Toggle line blame")
map("<leader>gd", "<cmd>Gitsigns diffthis<CR>", "Git Diff this")
map("<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Git toggle current line blame")
map("<leader>gt", "<cmd>Gitsigns toggle_signs<CR>", "Gitsigns toggle")

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufNewFile", "BufReadPost" },
        cmd = { "Gitsigns" },
        opts = {},
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git" },
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Toggle LazyGit" }
        }
    },
    {
        "sindrets/diffview.nvim",
        event = 'VeryLazy'
    },   

}
