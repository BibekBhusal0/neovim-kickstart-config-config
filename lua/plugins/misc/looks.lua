local map = require 'utils.map'
local smear_cursor_enabled = true

return {
  {
    'uga-rosa/ccc.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { '<leader>cp', ':CccPick<CR>', desc = 'Color Picker' },
      { '<leader>cP', ':CccConvert<CR>', desc = 'Color Convert' },
      { '<leader>ch', ':CccHighlighterToggle<CR>', desc = 'Color Highlighter Toggle' },
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
    ft = { 'markdown' },
    config = function()
      require('render-markdown').setup {}
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
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = function()
      local builtin = require 'statuscol.builtin'
      return {
        setopt = true,
        segments = {
          { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa', auto = true },
          { text = { builtin.lnumfunc, '' }, click = 'v:lua.ScLa', auto = true },
          {
            sign = { namespace = { 'diagnostic/signs' }, auto = true },
            click = 'v:lua.ScSa',
          },
          { sign = { namespace = { 'gitsigns' } }, click = 'v:lua.ScSa', auto = true },
        },
      }
    end,
  }, -- changes the status column which appears in left side

  {
    'petertriho/nvim-scrollbar',
    event = { 'BufNewFile', 'BufReadPost' },
    dependencies = {
      'kevinhwang91/nvim-hlslens',
      config = function()
        require('scrollbar.handlers.search').setup { calm_down = true, nearest_only = true }
        local cmd = "<Cmd>lua require('neoscroll').zz({half_win_duration = 100}) require('hlslens').start()<CR>"
        map('n', "<Cmd>execute('normal! ' . v:count1 . 'n')<CR>" .. cmd, 'Find Next')
        map('N', "<Cmd>execute('normal! ' . v:count1 . 'N')<CR>" .. cmd, 'Find Previous')
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
    keys = { { '<leader>F', '<cmd>Twilight<cr>', desc = 'Toggle Twilight' } },
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
