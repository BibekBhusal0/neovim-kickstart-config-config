local map = require 'utils.map'
local wrap_keys = require 'utils.wrap_keys'

return {
  {
    'uga-rosa/ccc.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    keys = wrap_keys {
      { '<leader>cP', ':CccPick<CR>', desc = 'Color Picker' },
      { '<leader>cm', ':CccConvert<CR>', desc = 'Color Convert' },
      { '<leader>cH', ':CccHighlighterToggle<CR>', desc = 'Color Highlighter Toggle' },
    },
    config = function()
      local ccc = require 'ccc'
      ccc.setup {
        default_color = '#c6c8d1',
        point_char = '░',
        highlighter = { auto_enable = true, lsp = true },
      }
    end,
  }, -- Color picker

  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion', 'vimwiki' },
    config = function()
      require('render-markdown').setup {
        file_type = { 'markdown', 'codecompanion', 'vimwiki' },
        link = {
          custom = {
            wikipedia = { pattern = 'wikiwand%.org', icon = '󰖬 ' },
            twitter = { pattern = 'twitter%.com', icon = ' ' },
            linkedin = { pattern = 'linkedin%.com', icon = ' ' },
          },
        },
      }
      map('<leader>mm', ':RenderMarkdown toggle<CR>', 'Markdown Render Toggle')
      map('<leader>mM', ':RenderMarkdown buf_toggle<CR>', 'Markdown Render Buffer Toggle')
    end,
  }, -- better markdown render

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufNewFile', 'BufReadPost' },
    opts = {
      indent = { char = '▏' },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          'help',
          'startify',
          'dashboard',
          'packer',
          'neogitstatus',
          'NvimTree',
          'Trouble',
          'alpha',
        },
      },
    },
  }, -- Better indentations

  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      require('lsp_lines').setup()
      vim.diagnostic.config { virtual_lines = { only_current_line = true }, virtual_text = false }
      map('<leader>lt', require('lsp_lines').toggle, 'Toggle LSP line')
    end,
    event = 'LspAttach',
  }, -- Better diagnostic messages

  {
    'folke/noice.nvim',
    event = { 'VeryLazy' },
    dependencies = {
      {
        'rcarriga/nvim-notify',
        opts = {
          icons = require('utils.icons').diagnostics,
          render = 'wrapped-default',
          stages = 'slide',
        },
      },
    },

    config = function()
      local noice = require 'noice'
      map('<leader>nr', ':Noice dismiss<CR>', 'Noice remove')
      map('<leader>nl', ':Noice last<CR>', 'Noice last')
      map('<leader>nh', ':Noice history<CR>', 'Noice history')
      map('<leader>ns', ':Telescope noice<CR>', 'Noice Telescope')
      map('<leader>nS', ':Telescope notify<CR>', 'Notify Telescope')
      map('<leader>nT', function()
        local running = require('noice.config')._running
        if running then
          noice.disable()
        else
          noice.enable()
        end
      end, 'Toggle Noice')
      noice.setup {
        level = { icons = require('utils.icons').diagnostics },
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
          progress = { enabled = false },
          hover = { enabled = true, silent = true },
        },
        presets = {
          bottom_search = false,
          inc_rename = true,
          lsp_doc_border = true,
        },
        cmdline = {
          format = {
            cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋖' },
            input = { view = 'cmdline_input', icon = '󰥻 ' },
          },
        },
        commands = {
          history = { view = 'popup' },
          last = { view = 'notify' },
          all = { view = 'popup' },
        },
      }
    end,
  },

  {
    'petertriho/nvim-scrollbar',
    event = { 'BufNewFile', 'BufReadPost' },
    dependencies = {
      'kevinhwang91/nvim-hlslens',
      config = function()
        require('scrollbar.handlers.search').setup { calm_down = true, nearest_only = true }
        local cmd = ":lua require('neoscroll').zz({half_win_duration = 100}) require('hlslens').start()<CR>"
        map('n', ":execute('normal! ' . v:count1 . 'n')<CR>" .. cmd, 'Find Next')
        map('N', ":execute('normal! ' . v:count1 . 'N')<CR>" .. cmd, 'Find Previous')
        map('*', '*' .. cmd, 'Find Word Under Cursor')
        map('#', '#' .. cmd, 'Find Word Before Cursor')
        map('g*', 'g*' .. cmd, 'Find Word Under Cursor')
        map('g#', 'g#' .. cmd, 'Find Word Before Cursor')
      end,
    },
    config = function()
      require('scrollbar').setup {
        show_in_active_only = true,
        hide_if_all_visible = true,
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
        },
      }
    end,
  }, -- scrollbar showing gitsigns and diagnostics

  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    keys = wrap_keys { { '<leader>F', ':Twilight<CR>', desc = 'Toggle Twilight' } },
    opts = { context = 10 },
  }, -- dim inactive code

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                       ANIMATIONS                        │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    'sphamba/smear-cursor.nvim',
    event = { 'CursorHold', 'CursorHoldI' },
    opts = {},
    config = function()
      local sm = require 'smear_cursor'
      sm.setup { cursor_color = '#ff8800' }
      sm.enabled = true
      map('<leader>tc', ':SmearCursorToggle<CR>', 'Toggle Smear Cursor')
    end,
  }, -- cursor animation

  {
    'karb94/neoscroll.nvim',
    keys = {
      { '<C-u>', mode = { 'n', 'v', 'x' } },
      { '<C-d>', mode = { 'n', 'v', 'x' } },
      { '<C-b>', mode = { 'n', 'v', 'x' } },
      { '<C-f>', mode = { 'n', 'v', 'x' } },
      { '<C-y>', mode = { 'n', 'v', 'x' } },
      { '<C-e>', mode = { 'n', 'v', 'x' } },
      { 'zt', mode = { 'n', 'v', 'x' } },
      { 'zz', mode = { 'n', 'v', 'x' } },
      { 'zb', mode = { 'n', 'v', 'x' } },
    },
    opts = { hide_cursor = true },
  }, -- Smooth scrolling
}
