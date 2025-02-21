map = require('utils.map')

local function commit_with_message()
    require'utils.input'(" Commit Message ", function(text) vim.cmd("Git commit -m '" .. text .. "'") end, '', 40)
end

local function commit_all_with_message()
    require'utils.input'(" Commit Message ", function(text)
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

local function diffViewTelescopeCompareWithHead()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    local select = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
            vim.cmd("DiffviewOpen HEAD.." .. selection.value)
        end
    end

    builtin.git_branches(themes.get_dropdown({
        previewer = false,
        prompt_title = "Compare HEAD with Branch",
        attach_mappings = function(_, map)
            map({ "i", "n" }, "<cr>", select)
            return true
        end
    }))
end

local function diffViewTelescopeFileHistory()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local themes = require("telescope.themes")
    local builtin = require("telescope.builtin")

    -- First select a file
    builtin.git_files(themes.get_dropdown({
        prompt_title = "Select File for History",
        previewer = false,
        attach_mappings = function(_, map)
            map({ "i", "n" }, "<CR>", function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                    -- Directly open file history for selected file
                    vim.cmd("DiffviewFileHistory " .. selection.path)
                end
            end)
            return true
        end
    }))
end

local function diffViewTelescopeCompareBranches()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local themes = require("telescope.themes")
    local builtin = require("telescope.builtin")
    local branches = {}

    -- First branch selection
    builtin.git_branches(themes.get_dropdown({
        prompt_title = "Select First Branch",
        attach_mappings = function(_, map)
        previewer = false,
            map({ "i", "n" }, "<CR>", function(first_bufnr)
                local first_branch = action_state.get_selected_entry().value
                actions.close(first_bufnr)

                -- Second branch selection
                builtin.git_branches(themes.get_dropdown({
                    prompt_title = "Select Second Branch",
                    previewer = false,
                    attach_mappings = function(_, second_map)
                        second_map({ "i", "n" }, "<CR>", function(second_bufnr)
                            local second_branch = action_state.get_selected_entry().value
                            actions.close(second_bufnr)

                            if first_branch ~= second_branch then
                                vim.cmd("DiffviewOpen " .. first_branch .. ".." .. second_branch)
                            else
                                vim.notify("Cannot compare identical branches", vim.log.levels.WARN)
                            end
                        end)
                        return true
                    end
                }))
            end)
            return true
        end
    }))
end

map("<leader>dO", "<cmd>DiffviewOpen<CR>", "Diffview open")
map("<leader>do", diffViewTelescopeCompareWithHead, "Diffview Compare with head")
map("<leader>dF", diffViewTelescopeFileHistory, "Diffview file history Telescope ")
map("<leader>db", diffViewTelescopeCompareBranches, "Diffview compare branches")
map("<leader>dc", "<cmd>DiffviewClose<CR>", "Diffview close")
map("<leader>df", "<cmd>DiffviewFileHistory %<CR>", "Diffview file history Current File")
map("<leader>dh", "<cmd>DiffviewFileHistory<CR>", "Diffview file history")

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
