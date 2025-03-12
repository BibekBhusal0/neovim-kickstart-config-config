map = require 'utils.map'

local function commit_with_message()
  require 'utils.input'(' Commit Message ', function(text)
    vim.cmd("Git commit -m '" .. text .. "'")
  end, '', 40, '  ')
end

local function commit_all_with_message()
  require 'utils.input'(' Commit Message ', function(text)
    vim.cmd("Git commit -a -m '" .. text .. "'")
  end, '', 50, '  ')
end

map('<leader>gp', ':Git push<CR>', 'Git push')
map('<leader>ga', ':Git add .<CR>', 'Git add all files')
map('<leader>gi', ':Git init<CR>', 'Git Init')
map('<leader>gA', ':Git add %<CR>', 'Git add current file')
map('<leader>gP', ':Git pull<CR>', 'Git pull')
map('<leader>gC', commit_with_message, 'Git commit')
map('<leader>gc', commit_all_with_message, 'Git commit all')

map('<leader>gs', ':Gitsigns stage_hunk<CR>', 'Git Stage hunk')
map('<leader>gr', ':Gitsigns reset_hunk<CR>', 'Git Reset hunk')
map('<leader>gS', ':Gitsigns stage_buffer<CR>', 'Git Stage buffer')
map('<leader>gR', ':Gitsigns reset_buffer<CR>', 'Git Reset buffer')
map('<leader>gh', ':Gitsigns preview_hunk<CR>', 'Git Preview hunk')
map('<leader>gH', ':Gitsigns preview_hunk_inline<CR>', 'Git Preview hunk inline')
map('<leader>gb', ':Gitsigns blame<CR>', 'Git Blame')
map('<leader>gB', ':Gitsigns blame_line<CR>', 'Git Toggle line blame')
map('<leader>gD', ':Gitsigns diffthis<CR>', 'Git Diff this')
map('<leader>gl', ':Gitsigns toggle_current_line_blame<CR>', 'Git toggle current line blame')
map('<leader>gt', ':Gitsigns toggle_signs<CR>', 'Gitsigns toggle')

-- Lua
local function disableAutowidth()
  local lazy = require 'lazy'
  local plugins = lazy.plugins()
  if plugins['windows.nvim'] and plugins['windows.nvim'].loaded then
    vim.cmd 'WindowsDisableAutowidth'
  end
end

local function diffViewTelescopeCompareWithCurrentBranch()
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local builtin = require 'telescope.builtin'
  local themes = require 'telescope.themes'
  local select = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    if selection then
      disableAutowidth()
      vim.cmd('DiffviewOpen ' .. selection.value)
    end
  end
  builtin.git_branches(themes.get_dropdown {
    previewer = false,
    prompt_title = 'Compare Current with Branch',
    attach_mappings = function(_, map)
      map({ 'i', 'n' }, '<cr>', select)
      return true
    end,
  })
end

local function diffViewTelescopeFileHistory()
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local themes = require 'telescope.themes'
  local builtin = require 'telescope.builtin'
  builtin.git_files(themes.get_dropdown {
    prompt_title = 'Select File for History',
    previewer = false,
    attach_mappings = function(_, map)
      map({ 'i', 'n' }, '<CR>', function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          disableAutowidth()
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
  local branches = {}
  -- First branch selection
  builtin.git_branches(themes.get_dropdown {
    prompt_title = 'Select First Branch',
    attach_mappings = function(_, map)
      previewer =
        false, map({ 'i', 'n' }, '<CR>', function(first_bufnr)
          local first_branch = action_state.get_selected_entry().value
          actions.close(first_bufnr)
          -- Second branch selection
          builtin.git_branches(themes.get_dropdown {
            prompt_title = 'Select Second Branch',
            previewer = false,
            attach_mappings = function(_, second_map)
              second_map({ 'i', 'n' }, '<CR>', function(second_bufnr)
                local second_branch = action_state.get_selected_entry().value
                actions.close(second_bufnr)
                if first_branch ~= second_branch then
                  disableAutowidth()
                  vim.cmd('DiffviewOpen ' .. first_branch .. '..' .. second_branch)
                else
                  vim.notify('Cannot compare identical branches', vim.log.levels.WARN)
                end
              end)
              return true
            end,
          })
        end)
      return true
    end,
  })
end

function diffViewOpen()
  disableAutowidth()
  vim.cmd 'DiffviewOpen'
end

function diffViewFileHistory()
  disableAutowidth()
  vim.cmd 'DiffviewFileHistory'
end

function diffviewFileHistoryCurrentFile()
  disableAutowidth()
  vim.cmd 'DiffviewFileHistory %'
end

return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufNewFile', 'BufReadPost' },
    cmd = { 'Gitsigns' },
    opts = {},
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'Git' },
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
    keys = { { '<leader>lg', ':LazyGit<cr>', desc = 'Toggle LazyGit' } },
  },

  {
    'sindrets/diffview.nvim',
    lazy = true,
    keys = {
      { '<leader>gdO', diffViewOpen, desc = 'DiffView Open' },
      { '<leader>gdo', diffViewTelescopeCompareWithCurrentBranch, desc = 'Diffview Compare with Current Files' },
      { '<leader>gdF', diffViewTelescopeFileHistory, desc = 'Diffview file history Telescope ' },
      { '<leader>gdb', diffViewTelescopeCompareBranches, desc = 'Diffview compare branches' },
      { '<leader>gdc', ':DiffviewClose<CR>', desc = 'Diffview close' },
      { '<leader>gdf', diffviewFileHistoryCurrentFile, desc = 'Diffview file history Current File' },
      { '<leader>gdh', diffViewFileHistory, desc = 'Diffview file history' },
    },
  },
}
