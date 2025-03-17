local map = require 'utils.map'
local wrap_keys = require 'utils.wrap_keys'
local webDev = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte' }

return {
  {
    'kylechui/nvim-surround',
    event = { 'InsertEnter' },
    config = function()
      require('nvim-surround').setup {}
    end,
  }, -- change brackets, quotes and surrounds

  {
    'echasnovski/mini.trailspace',
    keys = wrap_keys { { '<leader>tw', ':lua require("mini.trailspace").trim() <CR>', desc = 'Trim Whitespace' } },
  }, -- Simple ways to train whitespace useful when formatter is not working

  {
    'nacro90/numb.nvim',
    opts = {},
    keys = {
      { '0', mode = 'c' },
      { '1', mode = 'c' },
      { '2', mode = 'c' },
      { '3', mode = 'c' },
      { '4', mode = 'c' },
      { '5', mode = 'c' },
      { '6', mode = 'c' },
      { '7', mode = 'c' },
      { '8', mode = 'c' },
      { '9', mode = 'c' },
    },
  }, -- Preview of line from command mode

  {
    'altermo/ultimate-autopair.nvim',
    keys = {
      { '{', mode = { 'i', 'c' } },
      { '[', mode = { 'i', 'c' } },
      { '(', mode = { 'i', 'c' } },
      { '"', mode = { 'i', 'c' } },
      { "'", mode = { 'i', 'c' } },
      { '`', mode = { 'i', 'c' } },
      { '}', mode = { 'i', 'c' } },
      { ']', mode = { 'i', 'c' } },
      { ')', mode = { 'i', 'c' } },
    },
    config = true,
  }, -- Autoclose parentheses, brackets, quotes, etc. also work on command mode

  {
    'windwp/nvim-ts-autotag',
    config = true,
    ft = webDev,
  }, -- Autoclose HTML tags

  {
    'mg979/vim-visual-multi',
    keys = { '<C-n>', '<C-Up>', '<C-Down>', '<S-Left>', '<S-Right>' },
    config = function()
      local hlslens = require 'hlslens'
      if hlslens then
        local overrideLens = function(render, posList, nearest, idx, relIdx)
          local _ = relIdx
          local lnum, col = unpack(posList[idx])
          local text, chunks
          if nearest then
            text = ('[%d/%d]'):format(idx, #posList)
            chunks = { { ' ', 'Ignore' }, { text, 'VM_Extend' } }
          else
            text = ('[%d]'):format(idx)
            chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
        local lensBak
        local config = require 'hlslens.config'
        local gid = vim.api.nvim_create_augroup('VMlens', {})
        vim.api.nvim_create_autocmd('User', {
          pattern = { 'visual_multi_start', 'visual_multi_exit' },
          group = gid,
          callback = function(ev)
            if ev.match == 'visual_multi_start' then
              lensBak = config.override_lens
              config.override_lens = overrideLens
            else
              config.override_lens = lensBak
            end
            hlslens.start()
          end,
        })
      end
    end,
  }, -- multi line editing

  {
    'nguyenvukhang/nvim-toggler',
    keys = wrap_keys { { '<leader>tt', ':lua require("nvim-toggler").toggle() <CR>', desc = 'Toggle Value' } },
    config = function()
      require('nvim-toggler').setup {
        inverses = {
          ['neo-vim'] = 'vs-code',
          ['0'] = '1',
          show = 'hide',
        },
        remove_default_keybinds = true,
      }
    end,
  }, -- Toggle between true and false ; more

  {
    'luckasRanarison/tailwind-tools.nvim',
    ft = webDev,
    dependencies = {
      'razak17/tailwind-fold.nvim',
      opts = { ft = webDev },
    },
    config = function()
      require('tailwind-tools').setup {}
      map('<leader>Tf', ':TailwindFoldToggle<CR>', 'Tailwind Fold Toggle')
      map('<leader>TS', ':TailwindSort<CR>', 'Tailwind Sort')
      map('<leader>Ts', ':TailwindSortSelection<CR>', 'Tailwind Sort', 'v')
      map('<leader>Tc', ':TailwindColorToggle<CR>', 'Tailwind Color Toggle')
      map('<leader>st', ':Telescope tailwind classes<CR>', 'Search Tailwind Classes')
      map('<leader>Ts', ':Telescope tailwind classes<CR>', 'Tailwind search')
    end,
  }, -- tailwind color highlights folds and more

  {
    'jakewvincent/mkdnflow.nvim',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {
        mappings = {
          MkdnEnter = { { 'n', 'v', 'i' }, '<CR>' },
          MkdnTab = false,
          MkdnSTab = false,
          MkdnNextLink = { 'n', ']l' },
          MkdnPrevLink = { 'n', '[l' },
          MkdnNextHeading = { 'n', ']h' },
          MkdnPrevHeading = { 'n', '[h' },
          MkdnGoBack = { 'n', '<BS>' },
          MkdnGoForward = { 'n', '<Del>' },
          MkdnCreateLink = false,
          MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<A-p>' },
          MkdnFollowLink = false,
          MkdnDestroyLink = { 'n', '<M-CR>' },
          MkdnTagSpan = { 'v', '<M-CR>' },
          MkdnMoveSource = { 'n', '<F2>' },
          MkdnYankAnchorLink = { 'n', 'yaa' },
          MkdnYankFileAnchorLink = { 'n', 'yfa' },
          MkdnIncreaseHeading = { 'n', '+' },
          MkdnDecreaseHeading = { 'n', '-' },
          MkdnToggleToDo = { { 'n', 'i' }, '<C-h>' },
          MkdnNewListItem = false,
          MkdnNewListItemBelowInsert = { 'n', 'o' },
          MkdnNewListItemAboveInsert = { 'n', 'O' },
          MkdnExtendList = false,
          MkdnUpdateNumbering = { 'n', '<leader>nN' },
          MkdnTableNextCell = { 'i', ']C' },
          MkdnTablePrevCell = { 'i', '[C' },
          MkdnTableNextRow = false,
          MkdnTablePrevRow = { 'i', '<M-CR>' },
          MkdnTableNewRowBelow = { 'n', '<C-i>r' },
          MkdnTableNewRowAbove = { 'n', '<C-i>R' },
          MkdnTableNewColAfter = { 'n', '<C-i>c' },
          MkdnTableNewColBefore = { 'n', '<C-i>C' },
          MkdnFoldSection = { 'n', 'gf' },
          MkdnUnfoldSection = { 'n', 'gF' },
        },
        foldtext = { object_count_icon_set = 'nerdfont' },
      }
    end,
  }, -- Better editing in markdown

  {
    'gregorias/coerce.nvim',
    event = { 'BufNewFile', 'BufReadPost' },
    tag = 'v4.1.0',
    config = true,
  }, -- Changing case easily

  {
    'christoomey/vim-sort-motion',
    event = { 'BufNewFile', 'BufReadPost' },
    config = function()
      vim.g.sort_motion_flags = 'i'
    end,
  }, -- sorting with motion

  {
    'Wansmer/treesj',
    keys = wrap_keys {
      { 'ga', ':TSJToggle<CR>', desc = 'Toggle split object under cursor' },
      { 'gj', ':TSJJoin<CR>', desc = 'Join the object under cursor' },
      { 'gk', ':TSJSplit<CR>', desc = 'Split the object under cursor' },
    },
    opts = { use_default_keymaps = false, max_join_length = 10000 },
  }, -- advanced join and split

  {
    'booperlv/nvim-gomove',
    keys = wrap_keys {
      { '<S-j>', '<Plug>GoNSMDown', desc = 'Move down' },
      { '<S-k>', '<Plug>GoNSMUp', desc = 'Move up' },
      { '<S-j>', '<Plug>GoVSMDown', mode = 'x', desc = 'Move down' },
      { '<S-k>', '<Plug>GoVSMUp', mode = 'x', desc = 'Move up' },
      { '<C-A-j>', '<Plug>GoNSDDown', desc = 'Duplicate down' },
      { '<C-A-k>', '<Plug>GoNSDUp', desc = 'Duplicate up' },
      { '<A-j>', '<Plug>GoVSDDown', mode = 'x', desc = 'Duplicate down' },
      { '<A-k>', '<Plug>GoVSDUp', mode = 'x', desc = 'Duplicate up' },
    },
    opts = { map_defaults = false },
  }, -- simple moving and duplicating lines

  { -- comments
    {
      'numToStr/Comment.nvim',
      event = { 'BufNewFile', 'BufReadPost' },
      dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
      config = function()
        require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
      end,
    }, -- Easily comment visual regions/lines

    {
      'LudoPinelli/comment-box.nvim',
      keys = wrap_keys {
        { '<leader>CB', ':CBlcbox<CR>', desc = 'Comment box' },
        { '<leader>CL', ':CBlcline<CR>', desc = 'Comment Line' },
      },
      cmd = {
        'CBllbox',
        'CBllbox',
        'CBlcbox',
        'CBlrbox',
        'CBccbox',
        'CBcrbox',
        'CBcrbox',
        'CBrlbox',
        'CBrcbox',
        'CBrrbox',
        'CBalbox',
        'CBacbox',
        'CBarbox',
        'CBraline',
        'CBlcline',
        'CBlrline',
        'CBccline',
        'CBcrline',
        'CBcrline',
        'CBrlline',
        'CBrcline',
        'CBrrline',
        'CBcatalog',
      },
      opts = {},
      -- ╭─────────────────────────────────────────────────────────╮
      -- │                Makes comments like this                 │
      -- ╰─────────────────────────────────────────────────────────╯
    },

    {
      'folke/todo-comments.nvim',
      event = { 'BufNewFile', 'BufReadPost' },
      keys = wrap_keys {
        { '<leader>sc', ':TodoTelescope<CR>', desc = 'Todo Search Telescope' },
        { '<leader>cT', ':Trouble todo<CR>', desc = 'Todo Loc List' },
      },
      config = function()
        require('todo-comments').setup { signs = false }
      end,
    }, -- WARNING: Highlights todo, notes, etc in comments
  },
}
