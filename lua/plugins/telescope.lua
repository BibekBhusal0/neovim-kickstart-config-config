local map = vim.keymap.set

return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
    config = function()
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
                        ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
                        ['<C-l>'] = require('telescope.actions').select_default, -- open file
                    },
                },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'
        map('n', '<leader>sh', builtin.help_tags, { desc = 'Search Help' })
        map('n', '<leader>sk', builtin.keymaps, { desc = 'Search Keymaps' })
        map('n', '<leader>sf', builtin.find_files, { desc = 'Search Files' })
        map('n', '<leader>st', builtin.builtin, { desc = 'Search Telescope' })
        map('n', '<leader>sW', builtin.grep_string, { desc = 'Search current Word' })
        map('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
        map('n', '<leader>sr', builtin.resume, { desc = 'Search Resume' })
        map('n', '<leader>s.', builtin.oldfiles, { desc = 'Search recent Files' })
        map('n', '<leader><leader>', builtin.buffers, { desc = 'Search buffers' })
        map('n', '<leader>sw', builtin.live_grep, { desc = 'Search by Grep' })
        map('n', '<leader>sgb', builtin.git_branches, { desc = 'Search Git Branches' })
        map('n', '<leader>sgc', builtin.git_commits, { desc = 'Search Git Commits' })
        map('n', '<leader>sgC', builtin.git_bcommits, { desc = 'Search Git Bcommits' })
        map('n', '<leader>sgs', builtin.git_stash, { desc = 'Search Git Stash' })
        map('n', '<leader>sgf', builtin.git_files, { desc = 'Search Git Files' })

        -- Slightly advanced example of overriding default behavior and theme
        map('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        map('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch [/] in Open Files' })
    end,
}
