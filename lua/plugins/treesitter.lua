local map = require 'utils.map'
local mode = { 'n', 'x', 'o' }

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
          'yaml',
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
    'nvim-treesitter/nvim-treesitter-context',
    keys = {
      { '<leader>tC', ':TSContextToggle<cr>', desc = 'Toggle Treesitter Context' },
    },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('treesitter-context').setup { max_lines = 5 }
      map('<leader><Cr>', ':lua require("treesitter-context").go_to_context(vim.v.count1)<cr>', 'Go to context')
    end,
  },

  {
    'nvim-treesitter/playground',
    keys = {
      { '<leader>pc', ':TSHighlightCapturesUnderCursor<CR>', desc = 'Highlight Captures Under Cursor' },
      { '<leader>pt', ':TSPlaygroundToggle<CR>', desc = 'Toggle Treesiter Playground' },
    },
    cmd = { 'TSHighlightCapturesUnderCursor', 'TSPlaygroundToggle' },
  },

  {
    'ziontee113/syntax-tree-surfer',
    keys = {
      { 'vn', ':STSSelectCurrentNode<cr>', desc = 'Select Current Node' },
      { 'vd', ':STSSwapDownNormal<cr>', desc = 'Swap Node Down' },
      { 'vu', ':STSSwapUpNormal<cr>', desc = 'Swap Node Up' },
      { 'vU', ':STSSwapCurrentNodePrevNormal<cr>', desc = 'Swap Node Previous' },
      { 'vD', ':STSSwapCurrentNodeNextNormal<cr>', desc = 'Swap Node Next' },
      { 'gS', ':STSSwapOrHold<cr>', desc = 'Swap Or Hold Node' },
      { 'gS', ':STSSwapOrHoldVisual<cr>', desc = 'Swap Or Hold Node', mode = 'x' },
      {
        '<leader>j',
        function()
          require('syntax-tree-surfer').targeted_jump {
            'start_tag',
            'arrow_function',
            'function_definition',
            'jsx_element',
            'jsx_self_closing_element',
            'function_declaration',
            'return_statement',
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
            'import_statement',
            'start_tag',
            'end_tag',
            'open_tag',
            'close_tag',
            'jsx_closing_element',
            'jsx_opening_element',
            'jsx_self_closing_element',
            'function_call',
            'variable_declaration',
            'lexical_declaration',
          }
        end,
        desc = 'Jump to next',
      },
    },
    opts = {},
  },

  {
    'aaronik/treewalker.nvim',
    opts = {},
    cmd = { 'Treewalker' },
    keys = {
      { 'zh', ':Treewalker Left<CR>', mode = 'n' },
      { 'zl', ':Treewalker Right<CR>', mode = 'n' },
      { 'zk', ':Treewalker Up<CR>', mode = 'n' },
      { 'zj', ':Treewalker Down<CR>', mode = 'n' },
    },
  },

  {
    'drybalka/tree-climber.nvim',
    keys = {
      {
        'm',
        ':lua require("tree-climber").goto_parent() require("tree-climber").select_node()<cr>',
        desc = 'Goto Parent',
        mode = 'v',
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local keys = {
        ['/'] = 'comment',
        b = 'block',
        c = 'class',
        f = 'function',
        i = 'conditional',
        j = 'jsx',
        l = 'loop',
        P = 'parameter',
        r = 'return',
      }
      local keymaps = {}
      local goto_next_start = {}
      local goto_previous_start = {}
      local swap_next = {}
      local swap_previous = {}
      local goto_next_end = {}
      local goto_previous_end = {}

      for k, v in pairs(keys) do
        keymaps['i' .. k] = { query = '@' .. v .. '.inner', desc = 'Inner ' .. v }
        keymaps['a' .. k] = { query = '@' .. v .. '.outer', desc = 'Outer ' .. v }
        goto_next_start[']' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Next ' .. v }
        goto_previous_start['[' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Previous ' .. v }
        swap_next['<leader>m' .. k] = { query = '@' .. v .. '.outer', desc = 'Swap Next ' .. v }
        swap_previous['<leader>M' .. k] = { query = '@' .. v .. '.outer', desc = 'Swap Previous ' .. v }
        goto_previous_end['(' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Previous ' .. v .. ' End' }
        goto_next_end[')' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Next ' .. v .. ' End' }
      end
      goto_next_start[']z'] = { query = '@fold', query_group = 'folds', desc = 'Jump next fold' }
      goto_next_start['[z'] = { query = '@fold', query_group = 'folds', desc = 'Prev next fold' }

      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = keymaps,
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
            goto_next_end = goto_next_end,
            goto_previous_start = goto_previous_start,
            goto_previous_end = goto_previous_end,
          },
        },
      }

      local function call_require(module_name, call_function, parameter)
        return function()
          require(module_name)[call_function](parameter)
        end
      end

      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      local original_set_last_move = ts_repeat_move.set_last_move
      ts_repeat_move.set_last_move = function(move_fn, opts, ...)
        local success = original_set_last_move(move_fn, opts, ...)
        if success then
          vim.defer_fn(function()
            require('neoscroll').zz { half_win_duration = 10, hide_cursor = true }
          end, 5)
        end

        return success
      end

      local get_pair = ts_repeat_move.make_repeatable_move_pair
      local next_hunk, prev_hunk = get_pair(call_require('gitsigns', 'next_hunk'), call_require('gitsigns', 'prev_hunk'))
      local next_dig, prev_dig = get_pair(function()
        vim.diagnostic.goto_next { float = false }
      end, function()
        vim.diagnostic.goto_prev { float = false }
      end)
      local tw_next, tw_prev = get_pair(function()
        vim.cmd 'TailwindNextClass'
      end, function()
        vim.cmd 'TailwindPrevClass'
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
        map(']' .. k, next, 'Jump Next ' .. name, mode)
        map('[' .. k, prev, 'Jump Prev ' .. name, mode)
      end
      map(']g', next_hunk, 'Jump Next hunk', mode)
      map('[g', prev_hunk, 'Jump Previous hunk', mode)
      map(']d', next_dig, 'Jump Next Diagnostic', mode)
      map('[d', prev_dig, 'Jump Previous Diagnostic', mode)
      map(']n', tw_next, 'Jump Next Tailwind Class', mode)
      map('[n', tw_prev, 'Jump Previous Tailwind Class', mode)
      map('<A-j>', ts_repeat_move.repeat_last_move_next, 'Repeat last Jump Next', mode)
      map('<A-k>', ts_repeat_move.repeat_last_move_previous, 'Repat last Jump Previous', mode)
    end,
  },
}
