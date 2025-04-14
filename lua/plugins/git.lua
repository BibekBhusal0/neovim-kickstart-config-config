local wrap_keys = require 'utils.wrap_keys'
local map = require 'utils.map'

local function commit_with_message()
  require 'utils.input'(' Commit Message ', function(text)
    vim.cmd("Git commit -m '" .. text .. "'")
  end, '', 40, require('utils.icons').others.github .. '  ')
end

local function commit_all_with_message()
  require 'utils.input'(' Commit Message ', function(text)
    vim.cmd 'Git add .'
    vim.cmd("Git commit -am'" .. text .. "'")
  end, '', 50, require('utils.icons').others.github .. '  ')
end

local function change_last_commit_message()
  local handle = io.popen 'git log -1 --pretty=%B'
  if not handle then return end
  local message = handle:read '*a'
  handle:close()
  local m = message:match '^%s*(.-)%s*$'
  if not m then return end
  require 'utils.input'('Commit Message', function(title)
    local cmd = "Git commit --amend -m '" .. title .. "'"
    vim.cmd(cmd)
  end, m, 60, require('utils.icons').others.github .. '  ')
end

map('<leader>gA', ':Git add %<CR>', 'Git add current file')
map('<leader>ga', ':Git add .<CR>', 'Git add all files')
map('<leader>gc', commit_all_with_message, 'Git commit all')
map('<leader>gC', commit_with_message, 'Git commit')
map('<leader>ge', change_last_commit_message, 'Git change last commit message')
map('<leader>gi', ':Git init<CR>', 'Git Init')
map('<leader>gP', ':Git pull<CR>', 'Git pull')
map('<leader>gp', ':Git push<CR>', 'Git push')
map('<leader>g[', ':Git push --force<CR>', 'Git push Force')
map('<leader>g/', ':Git stash<CR>', 'Git stash')
map('<leader>gj', ':Git commit -a --amend --no-edit<CR>', 'Git add and commit to last commit')
map('<leader>gJ', ':Git commit --amend --no-edit<CR>', 'Git commit to last commit')

map('<leader>gb', ':Gitsigns blame<CR>', 'Git Blame')
map('<leader>gB', ':Gitsigns blame_line<CR>', 'Git Toggle line blame')
map('<leader>gD', ':lua require("gitsigns").diffthis("~")<CR>', 'Git Diff this')
map('<leader>Gd', ':lua require("gitsigns").toggle_deleted()<CR>', 'Git deleted diff')
map('<leader>gH', ':Gitsigns preview_hunk<CR>', 'Git Preview hunk')
map('<leader>gh', ':Gitsigns preview_hunk_inline<CR>', 'Git Preview hunk inline')
map('<leader>gl', ':Gitsigns toggle_current_line_blame<CR>', 'Git toggle current line blame')
map('<leader>gQ', ':Gitsigns setqflist all<CR>', 'Git quick fix list All')
map('<leader>gq', ':Gitsigns setqflist<CR>', 'Git quick fix list')
map('<leader>gR', ':Gitsigns reset_buffer<CR>', 'Git Reset buffer')
map('<leader>gr', ':Gitsigns reset_hunk<CR>', 'Git Reset hunk', { 'n', 'v' })
map('<leader>gS', ':Gitsigns stage_buffer<CR>', 'Git Stage buffer')
map('<leader>gs', ':Gitsigns stage_hunk<CR>', 'Git Stage hunk', { 'n', 'v' })
map('<leader>gt', ':Gitsigns toggle_signs<CR>', 'Gitsigns toggle')
map('<leader>gu', ':Gitsigns undo_stage_hunk<CR>', 'Git Undu hunk')
map('<leader>gW', ':lua require("gitsigns").toggle_word_diff()<CR>', 'Git Toggle word diff')
map('ag', ':lua require("gitsigns").select_hunk()<CR>', 'Select hunk', { 'o', 'x' })
map('ig', ':lua require("gitsigns").select_hunk()<CR>', 'Select hunk', { 'o', 'x' })

local function diffViewTelescopeFileHistory()
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local themes = require 'telescope.themes'
  local builtin = require 'telescope.builtin'
  builtin.git_files(themes.get_dropdown {
    prompt_title = 'Select File for History',
    previewer = false,
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry(prompt_bufnr)
        if selection then
          vim.cmd('DiffviewFileHistory ' .. selection.path)
        end
      end)
      return true
    end,
  })
end

local function diffViewTelescopeCompareBranches()
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local themes = require 'telescope.themes'
  local builtin = require 'telescope.builtin'

  builtin.git_branches(themes.get_dropdown {
    prompt_title = 'Select First Branch',
    previewer = false,
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()
        actions.close(prompt_bufnr)
        if #selections > 2 then
          vim.notify 'Must select 1 or 2 branches'
          return
        end
        local old = #selections == 0 and action_state.get_selected_entry().ordinal or selections[1].value
        if #selections == 2 then
          local new = string.sub(selections[2].value, 1, 8)
          vim.cmd(string.format('DiffviewOpen %s..%s', old, new))
        else
          vim.cmd(string.format('DiffviewOpen %s', old))
        end
        vim.cmd [[stopinsert]]
      end)
      return true
    end,
  })
end

map('<leader>gdb', diffViewTelescopeCompareBranches, 'Diffview compare branches')
map('<leader>gdF', diffViewTelescopeFileHistory, 'Diffview file history Telescope')

return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufNewFile', 'BufReadPost' },
    cmd = { 'Gitsigns' },
    opts = { numhl = true },
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiffsplit', 'Gedit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GRename', 'GDelete', 'GRemove', 'GBrowse' },
  },

  {
    'tpope/vim-rhubarb',
    cmd = { 'GBrowse' },
    keys = wrap_keys {
      { '<leader>go', ':GBrowse<CR>', desc = 'Git open in browser', mode = { 'n', 'v' } },
    },
  },

  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = wrap_keys { { '<leader>lg', ':LazyGit<CR>', desc = 'Toggle LazyGit' } },
  },

  {
    'sindrets/diffview.nvim',
    lazy = true,
    cmd = { 'Diffview', 'DiffviewOpen', 'DiffviewFileHistory' },
    opts = {
      hooks = {
        view_post_layout = function()
          if package.loaded['windows'] then
            vim.cmd 'WindowsDisableAutowidth'
          end
        end,
      },
    },
    keys = wrap_keys {
      { '<leader>gdx', ':DiffviewClose<CR>', desc = 'Diffview close' },
      { '<leader>gdf', ':DiffviewFileHistory %<CR>', desc = 'Diffview file history Current File' },
      { '<leader>gdh', ':DiffviewFileHistory<CR>', desc = 'Diffview file history' },
      { '<leader>gdo', ':DiffviewOpen<CR>', desc = 'DiffView Open' },
    },
  },

  {
    'polarmutex/git-worktree.nvim',
    keys = wrap_keys {
      { '<leader>gwn', ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", desc = 'Git Worktree New (Telescope)' },
      { '<leader>gww', ":lua require('telescope').extensions.git_worktree.git_worktree()<CR>", desc = 'Git Worktree (no)' },
      {
        '<leader>gws',
        function()
          require 'utils.input'('Worktree Name', function(text)
            require('git-worktree').switch_worktree(text)
          end, '', 50, require('utils.icons').others.github .. '  ')
        end,
        desc = 'Git Work tree switch',
      },
    },
    config = function()
      local Hooks = require 'git-worktree.hooks'
      local config = require 'git-worktree.config'
      Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
      Hooks.register(Hooks.type.DELETE, function(opts)
        vim.notify('Deleted ' .. opts.path)
        vim.cmd(config.update_on_change_command)
      end)
      require('telescope').load_extension 'git_worktree'
    end,
  },

  {
    'fredehoey/tardis.nvim',
    opts = {
      next = '<C-S-j>',
      prev = '<C-S-K>',
    },
    keys = wrap_keys { { '<leader>gg', ':Tardis git<CR>', desc = 'Git Time Travel' } },
  },

  {
    'paopaol/telescope-git-diffs.nvim',
    keys = wrap_keys { { '<leader>gdc', ':Telescope git_diffs  diff_commits previewer=false<CR>', desc = 'Diffview Compare commmits' } },
  },
}
