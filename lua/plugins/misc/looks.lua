local map = require "utils.map"
local wrap_keys = require "utils.wrap_keys"

return {
  {
    "uga-rosa/ccc.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = wrap_keys {
      { "<leader>cP", ":CccPick<CR>", desc = "Color Picker" },
      { "<leader>cm", ":CccConvert<CR>", desc = "Color Convert" },
      { "<leader>cH", ":CccHighlighterToggle<CR>", desc = "Color Highlighter Toggle" },
    },
    config = function()
      local ccc = require "ccc"
      ccc.setup {
        default_color = "#c6c8d1",
        point_char = "░",
        highlighter = { auto_enable = false, lsp = true },
      }
    end,
  }, -- Color picker

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufNewFile", "BufReadPost" },
    opts = {
      indent = { char = "▏" },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Trouble",
          "alpha",
        },
      },
    },
  }, -- Better indentations

  {
    -- 'folke/noice.nvim',
    -- event = { 'BufReadPost', 'BufNewFile', 'CmdLineEnter' },
    -- dependencies = {
    --   {
    --     'rcarriga/nvim-notify',
    --     opts = {
    --       icons = require('utils.icons').diagnostics,
    --       render = 'wrapped-default',
    --       stages = 'slide',
    --       max_width = 35,
    --       max_height = 50,
    --       top_down = false,
    --     },
    --   },
    -- },
    --
    -- config = function()
    --   local noice = require 'noice'
    --   map('<A-j>', function()
    --     noice.redirect(vim.fn.getcmdline())
    --   end, 'Redirect Cmdline', 'c')
    --   map('<leader>nr', ':Noice dismiss<CR>', 'Noice remove')
    --   map('<leader>nl', ':Noice last<CR>', 'Noice last')
    --   map('<leader>nh', ':Noice history<CR>', 'Noice history')
    --   map('<leader>ns', ':Telescope noice<CR>', 'Noice Telescope')
    --   map('<leader>nS', ':Telescope notify<CR>', 'Notify Telescope')
    --   map('<leader>nT', function()
    --     local running = require('noice.config')._running
    --     if running then
    --       noice.disable()
    --     else
    --       noice.enable()
    --     end
    --   end, 'Toggle Noice')
    --
    --   noice.setup {
    --     level = { icons = require('utils.icons').diagnostics },
    --     messages = { view_search = false },
    --     lsp = {
    --       override = {
    --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
    --         ['vim.lsp.util.stylize_markdown'] = true,
    --         ['cmp.entry.get_documentation'] = true,
    --       },
    --       progress = { enabled = true },
    --       hover = { enabled = false, silent = true },
    --     },
    --     presets = {
    --       inc_rename = true,
    --       lsp_doc_border = true,
    --     },
    --     cmdline = {
    --       format = {
    --         cmdline = { pattern = '^:', icon = '', lang = 'vim' },
    --         Visual = { pattern = "^:'<,'>", icon = '>', lang = 'vim' },
    --         Telescope = { pattern = '^:Telescope ', icon = '' },
    --         Trouble = { pattern = '^:Trouble ', icon = '' },
    --         gitsigns = { pattern = '^:Gitsigns ', icon = require('utils.icons').others.git },
    --         git = { pattern = '^:Git ', icon = require('utils.icons').others.github },
    --         ai = { pattern = '^:CodeCompanion ', icon = require('utils.icons').others.ai },
    --         help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋖' },
    --         input = { view = 'cmdline_input', icon = '󰥻 ' },
    --       },
    --     },
    --     commands = {
    --       history = { view = 'popup' },
    --       last = { view = 'notify' },
    --       all = { view = 'popup' },
    --     },
    --   }
    -- end,
  },

  {
    -- 'petertriho/nvim-scrollbar',
    -- event = { 'BufNewFile', 'BufReadPost' },
    --
    -- dependencies = {
    --   'kevinhwang91/nvim-hlslens',
    --   config = function()
    --     require('scrollbar.handlers.search').setup { calm_down = true, nearest_only = true }
    --     local cmd = ":lua require('neoscroll').zz({half_win_duration = 100}) require('hlslens').start()<CR>"
    --     map('n', ":execute('normal! ' . v:count1 . 'n')<CR>" .. cmd, 'Find Next')
    --     map('N', ":execute('normal! ' . v:count1 . 'N')<CR>" .. cmd, 'Find Previous')
    --     map('*', '*' .. cmd, 'Find Word Under Cursor')
    --     map('#', '#' .. cmd, 'Find Word Before Cursor')
    --     map('g*', 'g*' .. cmd, 'Find Word Under Cursor')
    --     map('g#', 'g#' .. cmd, 'Find Word Before Cursor')
    --   end,
    -- },
    --
    -- opts = {
    --   handle = { blend = 0 },
    --   marks = { Cursor = { color = '#00ff00' } },
    --   show_in_active_only = true,
    --   hide_if_all_visible = true,
    --   handlers = { gitsigns = true },
    -- },
  }, -- scrollbar showing gitsigns and diagnostics

  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = wrap_keys { { "<leader>F", ":Twilight<CR>", desc = "Toggle Twilight" } },
    opts = { context = 10 },
  }, -- dim inactive code
}
