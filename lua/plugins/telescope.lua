local wrap_keys = require 'utils.wrap_keys'
local map = require 'utils.map'
local spell = ':Telescope spell_suggest theme=get_cursor initial_mode=normal layout_config={width=40}<CR>'

local searchInLazy = function()
  require('telescope.builtin').find_files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy') }
end

local searchInConfig = function()
  require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end

map('<leader>/', ':Telescope current_buffer_fuzzy_find theme=dropdown previewer=false<CR>', 'Search in current buffer')
map('<leader>:', ':Telescope command_history<CR>', 'Search Commands history')
map('<leader>i', spell, 'Spell suggestion')
map('<leader>s.', ':Telescope oldfiles<CR>', 'Search recent Files')
map('<leader>s:', ':Telescope commands<CR>', 'Search Commands')
map('<leader>sA', ':Telescope autocommands<CR>', 'Search Autocommands')
map('<leader>sb', ':Telescope buffers<CR>', 'Search buffers in current tab')
map('<leader>sB', ':Telescope scope buffers<CR>', 'Seach All Buffers ')
map('<leader>sC', searchInConfig, 'Seach All Neovim Config')
map('<leader>sd', ':Telescope diagnostics<CR>', 'Search Diagnostics')
map('<leader>sf', ':Telescope find_files<CR>', 'Search Files')
map('<leader>sg/', ':Telescope git_stash<CR>', 'Search Git Stash')
map('<leader>sgb', ':Telescope git_branches<CR>', 'Search Git Branches')
map('<leader>sgC', ':Telescope git_bcommits<CR>', 'Search Git Commits of current buffer')
map('<leader>sgc', ':Telescope git_commits<CR>', 'Search Git Commits')
map('<leader>sgf', ':Telescope git_files<CR>', 'Search Git Files')
map('<leader>sgs', ':Telescope git_status<CR>', 'Search Git Status')
map('<leader>sh', ':Telescope harpoon marks<CR>', 'Search Harpoon Marks')
map('<leader>sH', ':Telescope help_tags<CR>', 'Search Help Tags')
map('<leader>sK', ':Telescope keymaps<CR>', 'Search Keymaps')
map('<leader>sL', searchInLazy, 'Search Lazy Plugins Files')
map('<leader>sm', ':Telescope marks<CR>', 'Search marks')
map('<leader>sq', ':Telescope quickfix<CR>', 'Search Quickfix list')
map('<leader>sr', ':Telescope resume<CR>', 'Search Resume')
map('<leader>ss', ':Telescope builtin<CR>', 'Search Telescope')
map('<leader>st', ':Telescope treesitter<CR>', 'Search Treesitter')
map('<leader>sv', ':Telescope vim_options<CR>', 'Search Files in split')
map('<leader>sW', ':Telescope grep_string<CR>', 'Search current Word')
map('<leader>sw', ':Telescope live_grep<CR>', 'Search by Grep')
map('<leader>sy', ':Telescope registers<CR>', 'Search registers')
map('<leader>sz', spell, 'Spell suggestion')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
        opts = {
          override = {
            deb = { icon = '', name = 'Deb' },
            lock = { icon = '󰌾', name = 'Lock' },
            mp3 = { icon = '󰎆', name = 'Mp3' },
            mp4 = { icon = '', name = 'Mp4' },
            ['robots.txt'] = { icon = '󰚩', name = 'Robots' },
            ttf = { icon = '', name = 'TrueTypeFont' },
            rpm = { icon = '', name = 'Rpm' },
            woff = { icon = '', name = 'WebOpenFontFormat' },
            woff2 = { icon = '', name = 'WebOpenFontFormat2' },
            xz = { icon = '', name = 'Xz' },
            zip = { icon = '', name = 'Zip' },
          },
        },
      },
      'prochri/telescope-all-recent.nvim',
      'kkharji/sqlite.lua',
    },

    config = function()
      local open_with_trouble = function(...)
        require('trouble.sources.telescope').open(...)
      end
      vim.g.sqlite_clib_path = 'C:/ProgramData/sqlite/sqlite3.dll'
      require('telescope-all-recent').setup {
        default = { sorting = 'frecency' },
      }
      require('telescope').setup {
        pickers = {
          find_files = { prompt_prefix = '󰈔 ' },
          live_grep = { prompt_prefix = '\\ ' },
          command_history = { prompt_prefix = ' ' },
          commands = { prompt_prefix = '  ' },
          diagnostics = { prompt_prefix = ' ' },
          git_branches = { prompt_prefix = require('utils.icons').others.git .. ' ' },
          git_bcommits = { prompt_prefix = require('utils.icons').others.git .. ' ' },
          git_commits = { prompt_prefix = require('utils.icons').others.git .. ' ' },
          git_files = { prompt_prefix = require('utils.icons').others.git .. ' ' },
          git_stash = { prompt_prefix = require('utils.icons').others.git .. ' ' },
          help_tags = { prompt_prefix = ' ' },
          builtin = { prompt_prefix = ' ' },
          spell_suggest = { prompt_prefix = '󰓆  ' },
        },
        defaults = {
          file_ignore_patterns = { '^node_modules', '^.git', '^.github', '^dist', '^build' },
          prompt_prefix = ' ',
          grep_ignore_patterns = { '**/package-lock.json', '**/pnpm-lock.yaml', '**/yarn.lock' },
          mappings = {
            i = {
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-l>'] = require('telescope.actions').select_default,
              ['<a-t>'] = require('telescope.actions').select_tab,
              ['<c-g>'] = open_with_trouble,
              ['<a-h>'] = require('telescope.actions').preview_scrolling_left,
              ['<a-l>'] = require('telescope.actions').preview_scrolling_right,
              ['<a-j>'] = require('telescope.actions').preview_scrolling_up,
              ['<a-k>'] = require('telescope.actions').preview_scrolling_down,
            },
            n = {
              ['<a-t>'] = require('telescope.actions').select_tab,
              ['<c-g>'] = open_with_trouble,
              ['<a-h>'] = require('telescope.actions').preview_scrolling_left,
              ['<a-l>'] = require('telescope.actions').preview_scrolling_right,
              ['<a-j>'] = require('telescope.actions').preview_scrolling_up,
              ['<a-k>'] = require('telescope.actions').preview_scrolling_down,
            },
          },
        },
        extensions = {
          git_diffs = { enable_preview_diff = false },
        },
      }
    end,
  },

  {
    'debugloop/telescope-undo.nvim',
    keys = wrap_keys { { '<leader>u', ':Telescope undo<CR>', desc = 'Undo Tree' } },
    cmd = { 'Telescope undo' },
  },

  {
    'zongben/proot.nvim',
    opts = {},
    keys = wrap_keys { { '<Leader>sp', ':Proot<CR>', desc = 'Search Directories' } },
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
    keys = wrap_keys {
      { '<leader>si', ':PickIcons<CR>', desc = 'Icon Picker' },
      { '<leader>sI', ':PickIconsYank<CR>', desc = 'Icon Picker Yank' },
      { '<leader>se', ':PickEmoji<CR>', desc = 'Icon Picker Emoji' },
      { '<leader>sS', ':PickSymbols<CR>', desc = 'Icon Picker Unicode Symbols' },
      { '<leader>sE', ':PickEmojiYank emoji<CR>', desc = 'Icon Picker Emoji Yank' },
    },
  }, -- icon picker with telescope

  {
    'tsakirist/telescope-lazy.nvim',
    keys = wrap_keys { { '<leader>sl', ':Telescope lazy<CR>', desc = 'Search Lazy Plugins Doc' } },
  },
}
