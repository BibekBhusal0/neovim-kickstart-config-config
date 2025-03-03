local map = require 'utils.map'

return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.install').compilers = { 'zig' }
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'lua',
          'python',
          'javascript',
          'typescript',
          'tsx',
          'css',
          'html',
          'vimdoc',
          'vim',
          'json',
          'gitignore',
          'markdown',
          'bash',
        },
        auto_install = true,
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true },
      }
    end,
  },

  {
    'ziontee113/syntax-tree-surfer',
    keys = {
      { 'vs', ':STSSelectMasterNode<cr>', desc = 'Select Master Node' },
      { 'vn', ':STSSelectCurrentNode<cr>', desc = 'Select Current Node' },
      { 'vD', ':STSSwapDownNormal<cr>', desc = 'Swap Node Down', mode = 'n' },
      { 'vU', ':STSSwapUpNormal<cr>', desc = 'Swap Node Up', mode = 'n' },
      { 'vu', ':STSSwapCurrentNodePrevNormal<cr>', desc = 'Swap Node Previous', mode = 'n' },
      { 'vd', ':STSSwapCurrentNodeNextNormal<cr>', desc = 'Swap Node Next', mode = 'n' },
      { 'gnh', ':STSSwapOrHold<cr>', desc = 'Swap Or Hold Node', mode = 'n' },
      { 'gnh', ':STSSwapOrHoldVisual<cr>', desc = 'Swap Or Hold Node', mode = 'x' },
      {
        '<leader>j',
        function()
          require('syntax-tree-surfer').targeted_jump {
            'arrow_function',
            'function_definition',
            'if_statement',
            'else_clause',
            'else_statement',
            'elseif_statement',
            'for_statement',
            'while_statement',
            'switch_statement',
          }
        end,
        desc = 'Jump to important',
      },
      {
        '<leader>J',
        function()
          require('syntax-tree-surfer').targeted_jump {
            'html_tag',
            'jsx_tag',
            'tag',
            'function_call',
            'variable_declaration',
          }
        end,
        desc = 'Jump to calls',
      },
    },
    opts = {},
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      keys = {
        b = 'block',
        c = 'class',
        C = 'comment',
        f = 'function',
        i = 'conditional',
        l = 'loop',
        P = 'parameter',
        r = 'return',
      }
      local keymsps = {}
      local goto_next_start = {}
      local goto_previous_start = {}
      local swap_next = {}
      local swap_previous = {}

      for k, v in pairs(keys) do
        keymsps['i' .. k] = { query = '@' .. v .. '.inner', desc = 'Inner ' .. v }
        keymsps['a' .. k] = { query = '@' .. v .. '.outer', desc = 'Outer ' .. v }
        goto_next_start[']' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Next ' .. v }
        goto_previous_start['[' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Previous ' .. v }
        swap_next['<leader>m' .. k] = { query = '@' .. v .. '.outer', desc = 'Swap Next ' .. v }
        swap_previous['<leader>M' .. k] = { query = '@' .. v .. '.outer', desc = 'Swap Previous ' .. v }
      end

      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = keymsps,
          },
          swap = {
            enable = true,
            swap_next = swap_next,
            swap_previous = swap_previous,
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = goto_next_start,
            goto_next_end = {},
            goto_previous_start = goto_previous_start,
            goto_previous_end = {},
          },
        },
      }

      function call_require(module_name, call_function, parameter)
        return function()
          require(module_name)[call_function](parameter)
        end
      end

      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
      local get_pair = ts_repeat_move.make_repeatable_move_pair
      local next_hunk, prev_hunk = get_pair(call_require('gitsigns', 'next_hunk'), call_require('gitsigns', 'prev_hunk'))
      local next_dig, prev_dig = get_pair(function()
        vim.diagnostic.goto_next { float = false }
      end, function()
        vim.diagnostic.goto_prev { float = false }
      end)

      local todos = {
        t = {},
        T = { 'TODO' },
        F = { 'FIX' },
        W = { 'WARN', 'WARNING' },
        H = { 'HACK' },
        N = { 'NOTE' },
      }
      for k, p in pairs(todos) do
        local next, prev = get_pair(call_require('todo-comments', 'jump_next', { keywords = p }), call_require('todo-comments', 'jump_prev', { keywords = p }))
        local name = #p == 0 and 'todo comment' or p[1]
        map(']' .. k, next, 'Jump Next ' .. name, { 'n', 'x', 'o' })
        map('[' .. k, prev, 'Jump Prev ' .. name, { 'n', 'x', 'o' })
      end

      map(']g', next_hunk, 'Jump Next hunk', { 'n', 'x', 'o' })
      map('[g', prev_hunk, 'Jump Previous hunk', { 'n', 'x', 'o' })
      map(']d', next_dig, 'Jump Next Diagnostic', { 'n', 'x', 'o' })
      map('[d', prev_dig, 'Jump Previous Diagnostic', { 'n', 'x', 'o' })
      map('<A-j>', ts_repeat_move.repeat_last_move_next, 'Repeat last Jump Next', { 'n', 'x', 'o' })
      map('<A-k>', ts_repeat_move.repeat_last_move_previous, 'Repat last Jump Previous', { 'n', 'x', 'o' })
    end,
  },
}
