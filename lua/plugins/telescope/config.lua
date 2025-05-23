return function()
  local open_with_trouble = function(...)
    require("trouble.sources.telescope").open(...)
  end

  local multi_selection_codecompanion = function(prompt_bufnr)
    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()

    local picker_type = picker.prompt_title or ""

    local is_codecompanion = string.find(picker_type, "Select file%(s%)")
      or string.find(picker_type, "Select buffer%(s%)")

    if is_codecompanion then
      require("telescope.actions").select_default(prompt_bufnr)
      return
    end

    if not vim.tbl_isempty(multi) then
      require("telescope.actions").close(prompt_bufnr)
      for _, j in pairs(multi) do
        if j.path ~= nil then
          if j.lnum ~= nil then
            vim.cmd(string.format("%s %s:%s", "edit", j.path, j.lnum))
          else
            vim.cmd(string.format("%s %s", "edit", j.path))
          end
        end
      end
    else
      require("telescope.actions").select_default(prompt_bufnr)
    end
  end

  local actions = require "telescope.actions"

  local all_cmd = function(open_callback)
    return function(prompt_bufnr)
      local action_state = require "telescope.actions.state"
      local picker = action_state.get_current_picker(prompt_bufnr)
      local selections = picker:get_multi_selection()
      actions.close(prompt_bufnr)
      if #selections == 0 then
        open_callback(action_state.get_selected_entry().ordinal, 1)
      end
      for i, selection in ipairs(selections) do
        open_callback(selection.value, i)
      end
    end
  end

  local yank_selected = function()
    local action_state = require "telescope.actions.state"
    vim.fn.setreg('"', action_state.get_selected_entry().ordinal)
  end

  local open_all_in_new_tab = all_cmd(function(val, i)
    vim.cmd((i > 1 and "edit " or "tabnew ") .. val)
  end)

  vim.g.sqlite_clib_path = "C:/ProgramData/sqlite/sqlite3.dll"
  require("telescope-all-recent").setup {
    default = { sorting = "frecency" },
  }
  local theme = require "telescope.themes"
  local get_dropdown = theme.get_dropdown
  local git_icon = require("utils.icons").others.git .. " "
  local grep = {
    prompt_prefix = "󱎸 ",
    path_display = { "shorten" },
    layout_config = { preview_width = 0.5 },
  }

  local mappings = {
    ["<a-a>"] = actions.select_all,
    ["<a-h>"] = actions.preview_scrolling_left,
    ["<a-k>"] = actions.preview_scrolling_up,
    ["<a-j>"] = actions.preview_scrolling_down,
    ["<a-l>"] = actions.preview_scrolling_right,
    ["<a-t>"] = actions.select_tab,
    ["<c-g>"] = open_with_trouble,
    ["<c-y>"] = yank_selected,
    ["<cr>"] = multi_selection_codecompanion,
  }

  require("telescope").setup {

    pickers = {
      live_grep = grep,
      grep_string = grep,
      find_files = {
        prompt_prefix = "󰈔 ",
        layout_config = { preview_width = 0.6 },
        mappings = {
          i = { ["<a-g>"] = open_all_in_new_tab },
          n = { ["<a-g>"] = open_all_in_new_tab },
        },
      },
      treesitter = {
        prompt_prefix = " ",
        layout_strategy = "vertical",
      },
      current_buffer_fuzzy_find = get_dropdown {
        prompt_prefix = "⚡ ",
        skip_empty_lines = true,
        previewer = false,
      },
      tags = {},
      current_buffer_tabs = {},
      git_files = {
        prompt_prefix = git_icon,
        layout_config = { preview_width = 0.6 },
      },
      git_commits = {
        prompt_prefix = git_icon,
      },
      git_bcommits = {
        prompt_prefix = git_icon,
      },
      git_branches = get_dropdown {
        prompt_prefix = git_icon,
        previewer = false,
      },
      git_stash = get_dropdown {
        prompt_prefix = git_icon,
      },
      git_status = {
        prompt_prefix = git_icon,
        git_icons = require("utils.icons").git,
      },
      builtin = {},
      picekrs = {},
      planets = {},
      symbols = {},
      commands = get_dropdown {
        prompt_prefix = "  ",
      },
      quickfix = {
        prompt_prefix = " ",
      },
      quickfixhistory = {
        prompt_prefix = " ",
      },
      loclist = {},
      oldfiles = {
        prompt_prefix = " ",
      },
      command_history = get_dropdown {
        prompt_prefix = " ",
      },
      search_history = get_dropdown {
        prompt_prefix = " ",
      },
      vim_options = get_dropdown {
        prompt_prefix = "󰍜 ",
      },
      help_tags = get_dropdown {
        prompt_prefix = " ",
        previewer = false,
        mappings = {
          i = {
            ["<CR>"] = require("telescope.actions").select_vertical,
          },
          n = {
            ["<CR>"] = require("telescope.actions").select_vertical,
          },
        },
      },
      man_pages = {},
      reloader = {},
      buffers = {
        sort_lastused = true,
        initial_mode = "normal",
        layout_strategy = "vertical",
      },
      colorscheme = {
        enable_preview = true,
        prompt_prefix = "  ",
      },
      marks = {
        prompt_prefix = " ",
        layout_config = { preview_width = 0.4 },
        mappings = {
          i = { ["<a-m>"] = actions.delete_mark },
          n = { ["<a-m>"] = actions.delete_mark },
        },
      },
      registers = get_dropdown {
        prompt_prefix = "󰆒 ",
      },
      keymaps = get_dropdown {
        prompt_prefix = "  ",
      },
      filetypes = {},
      highlights = {},
      autocommands = {},
      spell_suggest = theme.get_cursor {
        prompt_prefix = "󰓆  ",
        initial_mode = "normal",
        layout_config = { width = 30 },
        prompt_title = "Spell",
      },
      tagstack = {},
      jumplist = {},
      lsp_references = get_dropdown { initial_mode = "normal" },
      lsp_incomming_calls = {},
      lsp_outgoing_calls = {},
      lsp_definitions = get_dropdown { initial_mode = "normal" },
      lsp_type_definitions = get_dropdown { initial_mode = "normal" },
      lsp_implementations = {},
      lsp_document_symbols = {},
      lsp_workspace_symbols = {},
      lsp_dynamic_workspace_symbols = {},
      diagnostics = {
        prompt_prefix = " ",
      },
    },

    defaults = {
      path_display = { "truncate", truncate = 2 },
      file_ignore_patterns = { "^node_modules", "^.git", "^.github", "^dist", "^build" },
      prompt_prefix = " ",
      entry_prefix = " ",
      selection_caret = " ",
      multi_icon = " ",
      grep_ignore_patterns = { "**/package-lock.json", "**/pnpm-lock.yaml", "**/yarn.lock" },

      mappings = {
        i = vim.tbl_extend("force", mappings, {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-l>"] = actions.select_default,
        }),
        n = vim.tbl_extend("force", mappings, {
          ["l"] = actions.select_default,
        }),
      },
    },
  }
end
