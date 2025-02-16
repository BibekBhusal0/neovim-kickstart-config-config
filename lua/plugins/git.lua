-- local map = vim.api.nvim_set_keymap
local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

local function commit_with_message()
    local commit_message = vim.fn.input("Commit message: ")
    if commit_message ~= "" then
        vim.cmd("Git commit -m '" .. commit_message .. "'")
    else
        print("Commit message cannot be empty.")
    end
end

local function commit_all_with_message()
    local commit_message = vim.fn.input("Commit message: ")
    if commit_message ~= "" then
        vim.cmd("Git commit -a -m '" .. commit_message .. "'")
    else
        print("Commit message cannot be empty.")
    end
end


return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
            map("<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", "Git Stage hunk")
            map("<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", "Git Reset hunk")
            map("<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", "Git Stage buffer")
            map("<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", "Git Reset buffer")
            map("<leader>gh", "<cmd>Gitsigns preview_hunk<CR>", "Git Preview hunk")
            map("<leader>gb", "<cmd>Gitsigns blame<CR>", "Git Blame")
            map("<leader>gB", "<cmd>Gitsigns blame_line<CR>", "Git Toggle line blame")
            map("<leader>gd", "<cmd>Gitsigns diffthis<CR>", "Git Diff this")
            map("<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Git toggle current line blame")
            map("<leader>gt", "<cmd>Gitsigns toggle_signs<CR>", "Gitsigns toggle")
        end
    },
    {
        'tpope/vim-fugitive',
        config = function()
            map("<leader>gp", "<cmd>Git push<CR>", "Git push")
            map("<leader>ga", "<cmd>Git add .<CR>", "Git add all files")
            map("<leader>gi", "<cmd>Git init<CR>", "Git Init")
            map("<leader>gA", "<cmd>Git add %<CR>", "Git add current file")
            map("<leader>gP", "<cmd>Git pull<CR>", "Git pull")
            map("<leader>gcm", commit_with_message, "Git commit with message")
            map("<leader>gcM", "<cmd>Git commit<CR>", "Git commit Without Message")
            map("<leader>gca", commit_all_with_message, "Git commit all with message prompt")
            map("<leader>gcA", "<cmd>Git commit -a<CR>", "Git commit all Withoug Message")
        end
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
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
}
