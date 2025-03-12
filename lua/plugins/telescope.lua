local searchInCurrentBuffer = function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end

local spellSuggestion = function()
  require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor {
    previewer = false,
    default_index = 1,
    layout_config = { width = 40 },
    initial_mode = 'normal',
  })
end

local searchInOpenFiles = function()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

local searchInLazy = function()
  require('telescope.builtin').find_files {
    cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy'),
  }
end

local map = require 'utils.map'

map('<leader>/', searchInCurrentBuffer, 'Search in current buffer')
map('<leader>:', ':Telescope command_history<CR>', 'Search Commands history')
map('<leader>i', spellSuggestion, 'Spell suggestion')
map('<leader>s.', ':Telescope oldfiles<CR>', 'Search recent Files')
map('<leader>s/', searchInOpenFiles, 'Search in Open Files')
map('<leader>s:', ':Telescope commands<CR>', 'Search Commands')
map('<leader>sb', ':Telescope buffers<CR>', 'Search buffers in current tab')
map('<leader>sB', ':Telescope scope buffers<CR>', 'Seach All Buffers ')
map('<leader>sd', ':Telescope diagnostics<CR>', 'Search Diagnostics')
map('<leader>sf', ':Telescope frecency workspace=CWD<CR>', 'Search Files')
map('<leader>sgb', ':Telescope git_branches<CR>', 'Search Git Branches')
map('<leader>sgC', ':Telescope git_bcommits<CR>', 'Search Git Bcommits')
map('<leader>sgc', ':Telescope git_commits<CR>', 'Search Git Commits')
map('<leader>sgf', ':Telescope git_files<CR>', 'Search Git Files')
map('<leader>sgs', ':Telescope git_stash<CR>', 'Search Git Stash')
map('<leader>sh', ':Telescope harpoon marks<CR>', 'Search Harpoon Marks')
map('<leader>sH', ':Telescope help_tags<CR>', 'Search Help Tags')
map('<leader>sL', searchInLazy, 'Search Lazy Plugins Files')
map('<leader>sr', ':Telescope resume<CR>', 'Search Resume')
map('<leader>ss', ':Telescope builtin<CR>', 'Search Telescope')
map('<leader>sW', ':Telescope grep_string<CR>', 'Search current Word')
map('<leader>sw', ':Telescope live_grep<CR>', 'Search by Grep')
map('<leader>sz', spellSuggestion, 'Spell suggestion')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-frecency.nvim',
    },

    config = function()
      local open_with_trouble = require('trouble.sources.telescope').open
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
              ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
              ['<C-l>'] = require('telescope.actions').select_default, -- open file
              ['<c-g>'] = open_with_trouble,
            },
            n = { ['<c-g>'] = open_with_trouble },
          },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'frecency')
    end,
  },

  {
    'debugloop/telescope-undo.nvim',
    keys = { { '<leader>u', ':Telescope undo<cr>', desc = 'Undo Tree' } },
    cmd = { 'Telescope undo' },
  },

  {
    'zongben/proot.nvim',
    opts = {},
    keys = { { '<Leader>sp', ':Proot<Cr>', desc = 'Search Directories' } },
    cmd = { 'Proot' },
  },

  {
    'ziontee113/icon-picker.nvim',
    opts = {},
    cmd = {
      'IconPickerInsert',
      'IconPickerNormal',
      'IconPickerYank',
      'PickIcons',
      'PickIconsYank',
      'PickEmoji',
      'PickEmojiYank',
      'PickEverything',
      'PickEverythingYank',
      'PickSymbols',
      'PickSymbolsYank',
    },
    keys = {
      { '<leader>si', '<cmd>PickIcons<cr>', desc = 'Icon Picker' },
      { '<leader>sI', '<cmd>PickIconsYank<cr>', desc = 'Icon Picker Yank' },
      { '<leader>se', '<cmd>PickEmoji<cr>', desc = 'Icon Picker Emoji' },
      { '<leader>sS', '<cmd>PickSymbols<cr>', desc = 'Icon Picker Unicode Symbols' },
      { '<leader>sE', '<cmd>PickEmojiYank emoji<cr>', desc = 'Icon Picker Emoji Yank' },
    },
  }, -- icon picker with telescope

  {
    'dhruvmanila/browser-bookmarks.nvim',
    keys = { { '<leader>B', ':BrowserBookmarks<cr>' } },
    config = function()
      require('telescope').load_extension 'bookmarks'
      require('browser_bookmarks').setup {
        profile_name = 'Bibek',
        url_open_command = 'start brave',
      }
    end,
  },

  {
    'tsakirist/telescope-lazy.nvim',
    keys = { { '<leader>sl', ':Telescope lazy<cr>', desc = 'Search Lazy Plugins Doc' } },
  },
}
