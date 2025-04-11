local showTree = function()
  vim.cmd [[Neotree toggle position=left]]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
end

local map = require 'utils.map'
map('<C-g>', showTree, 'Neotree Toggle', { 'n', 'v', 'i' })
map('<leader>E', ':Neotree float <CR>', 'Neotree Floating')
map('<leader>e', ':Neotree toggle position=right<CR>', 'Neotree on Right')
map('<leader>gf', ':Neotree float git_status <CR>', 'Git changes in files')
map('<leader>q', ':Neotree toggle position=left<CR>', 'Neotree on Left')

local lsp_operations = function(name)
  return function(...)
    local params = { ... }
    require('lsp-file-operations').setup()
    params[1].commands[name](..., function()
      params[1].commands.refresh(unpack(params))
    end)
  end
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = { 'Neotree' },

  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },

  config = function()
    require('neo-tree').setup {
      close_if_last_window = false,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sort_case_insensitive = false,
      sort_function = nil,
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          with_expanders = nil,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = require('utils.icons').files,
        modified = {
          symbol = '',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = require('utils.icons').git,
        },
        diagnostics = {
          symbols = require('utils.icons').diagnostics,
        },
        file_size = { enabled = true, required_width = 64 },
        type = { enabled = true, required_width = 122 },
        last_modified = { enabled = true, required_width = 88 },
        created = { enabled = true, required_width = 110 },
        symlink_target = { enabled = false },
      },
      -- see `:h neo-tree-custom-commands-global`
      commands = {},

      window = {
        position = 'left',
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<'] = 'prev_source',
          ['<2-LeftMouse>'] = 'open',
          ['<CR>'] = 'open',
          ['<esc>'] = 'cancel',
          ['<space>'] = { 'toggle_node', nowait = false },
          ['>'] = 'next_source',
          ['?'] = 'show_help',
          ['A'] = 'add_directory',
          ['a'] = { 'add', config = { show_path = 'none' } },
          ['C'] = 'close_node',
          ['c'] = 'copy',
          ['d'] = 'delete',
          ['e'] = lsp_operations 'rename_basename',
          ['h'] = 'open_split',
          ['i'] = 'show_file_details',
          ['l'] = 'open',
          ['m'] = lsp_operations 'move',
          ['p'] = lsp_operations 'paste_from_clipboard',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['r'] = lsp_operations 'rename',
          ['T'] = 'open_tab_drop',
          ['t'] = 'open_tabnew',
          ['v'] = 'open_vsplit',
          ['w'] = 'open_with_window_picker',
          ['x'] = 'cut_to_clipboard',
          ['y'] = 'copy_to_clipboard',
          ['z'] = 'close_all_nodes',
          ['Z'] = 'expand_all_nodes',
        },
      },
      nesting_rules = {},

      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_name = {
            '.DS_Store',
            'thumbs.db',
            'node_modules',
            '__pycache__',
            '.virtual_documents',
            -- ".git",
            '.python-version',
            '.venv',
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          never_show = {
            '.DS_Store',
            'thumbs.db',
          },
          never_show_by_pattern = {
            '.null-ls_*',
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        window = {
          mappings = {
            ['#'] = 'fuzzy_sorter',
            ['.'] = 'set_root',
            ['/'] = 'fuzzy_finder',
            ['<bs>'] = 'navigate_up',
            ['<c-x>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
            ['D'] = 'fuzzy_finder_directory',
            ['f'] = 'filter_on_submit',
            ['H'] = 'toggle_hidden',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['og'] = { 'order_by_git_status', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
          fuzzy_finder_mappings = {
            ['<C-n>'] = 'move_cursor_down',
            ['<C-p>'] = 'move_cursor_up',
            ['<down>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
          },
        },
      },

      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ['.'] = 'set_root',
            ['<bs>'] = 'navigate_up',
            ['bd'] = 'buffer_delete',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
        },
      },

      git_status = {
        window = {
          position = 'float',
          mappings = {
            ['A'] = 'git_add_all',
            ['g'] = { 'show_help', nowait = false, config = { title = 'Git actions', prefix_key = 'g' } },
            ['ga'] = 'git_add_file',
            ['gc'] = 'git_commit',
            ['gg'] = 'git_commit_and_push',
            ['gp'] = 'git_push',
            ['gr'] = 'git_revert_file',
            ['gu'] = 'git_unstage_file',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
        },
      },
    }
  end,
}
