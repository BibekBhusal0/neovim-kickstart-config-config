local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

local searchInLazy = function()
  require("telescope.builtin").find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
end

local searchInConfig = function()
  require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
end

local searchInCurrentBufferDir = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    require("telescope.builtin").find_files { cwd = vim.loop.cwd() }
  else
    require("telescope.builtin").find_files { cwd = vim.fn.fnamemodify(current_file, ":h") }
  end
end

local searchOpenFiles =
  ":Telescope live_grep theme=dropdown grep_open_files=true prompt_title=Search<CR>"

map("<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", "Search in current buffer")
map("<leader>:", ":Telescope command_history<CR>", "Search Commands history")
map("<leader>i", ":Telescope spell_suggest<CR>", "Spell suggestion")
map("<leader>s.", ":Telescope oldfiles<CR>", "Search recent Files")
map("<leader>s/", searchOpenFiles, "Search in Open Files")
map("<leader>s:", ":Telescope commands<CR>", "Search Commands")
map("<leader>sA", ":Telescope autocommands<CR>", "Search Autocommands")
map("<leader>sb", ":Telescope buffers<CR>", "Search buffers in current tab")
map("<leader>sB", ":Telescope scope buffers layout_strategy=vertical<CR>", "Search All Buffers ")
map("<leader>sC", searchInConfig, "Search All Neovim Config")
map("<leader>sd", ":Telescope diagnostics<CR>", "Search Diagnostics")
map("<leader>sf", ":Telescope find_files<CR>", "Search Files")
map("<leader>sg/", ":Telescope git_stash<CR>", "Search Git Stash")
map("<leader>sgb", ":Telescope git_branches<CR>", "Search Git Branches")
map("<leader>sgC", ":Telescope git_bcommits<CR>", "Search Git Commits of current buffer")
map("<leader>sgc", ":Telescope git_commits<CR>", "Search Git Commits")
map("<leader>sgf", ":Telescope git_files<CR>", "Search Git Files")
map("<leader>sgm", ":Telescope marks mark_type=gloabl<CR>", "Search marks global")
map("<leader>sgs", ":Telescope git_status<CR>", "Search Git Status")
map("<leader>sh", ":Telescope harpoon marks layout_strategy=vertical<CR>", "Search Harpoon Marks")
map("<leader>sH", ":Telescope help_tags<CR>", "Search Help Tags")
map("<leader>sj", searchInCurrentBufferDir, "Telescope search in current buffer directory")
map("<leader>sK", ":Telescope keymaps<CR>", "Search Keymaps")
map("<leader>sL", searchInLazy, "Search Lazy Plugins Files")
map("<leader>sM", ":Telescope marks mark_type=all<CR>", "Search marks all")
map("<leader>sm", ":Telescope marks mark_type=local<CR>", "Search marks")
map("<leader>sq", ":Telescope quickfix<CR>", "Search Quickfix list")
map("<leader>sr", ":Telescope resume<CR>", "Search Resume")
map("<leader>ss", ":Telescope builtin<CR>", "Search Telescope")
map("<leader>sT", ":Telescope treesitter<CR>", "Search Treesitter")
map("<leader>sv", ":Telescope vim_options<CR>", "Search Files in split")
map("<leader>sW", ":Telescope grep_string<CR>", "Search current Word")
map("<leader>sw", ":Telescope live_grep<CR>", "Search by Grep")
map("<leader>sy", ":Telescope registers<CR>", "Search registers")
map("<leader>sz", ":Telescope spell_suggest<CR>", "Spell suggestion")

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
          override = {
            deb = { icon = "", name = "Deb" },
            lock = { icon = "󰌾", name = "Lock" },
            mp3 = { icon = "󰎆", name = "Mp3" },
            mp4 = { icon = "", name = "Mp4" },
            ["robots.txt"] = { icon = "󰚩", name = "Robots" },
            ttf = { icon = "", name = "TrueTypeFont" },
            rpm = { icon = "", name = "Rpm" },
            woff = { icon = "", name = "WebOpenFontFormat" },
            woff2 = { icon = "", name = "WebOpenFontFormat2" },
            xz = { icon = "", name = "Xz" },
            zip = { icon = "", name = "Zip" },
          },
        },
      },
      "prochri/telescope-all-recent.nvim",
      "kkharji/sqlite.lua",
    },

    config = function()
      require "dressing"
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

      local fb_actions = require "telescope._extensions.file_browser.actions"
      local mappings = {
        ["<a-a>"] = actions.select_all,
        ["<a-h>"] = actions.preview_scrolling_left,
        ["<a-j>"] = actions.preview_scrolling_up,
        ["<a-k>"] = actions.preview_scrolling_down,
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
            show_line = false,
            symbol_width = 18,
            layout_strategy = "vertical",
            layout_config = { preview_width = 0.7 },
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

        extensions = {
          git_diffs = { enable_preview_diff = false },
          lazy = { theme = "dropdown", previewer = false },
          file_browser = {
            layout_strategy = "vertical",
            select_buffer = true,
            hide_parent_dir = true,
            collapse_dirs = true,
            prompt_path = true,
            dir_icon = "",
            git_status = true,
            mappings = {
              ["i"] = {
                ["<C-h>"] = fb_actions.backspace,
              },
              ["n"] = {
                ["<bs>"] = fb_actions.backspace,
                ["h"] = fb_actions.backspace,
                ["H"] = fb_actions.toggle_hidden,
                ["n"] = fb_actions.create,
              },
            },
          },
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      }
    end,
  },

  {
    "debugloop/telescope-undo.nvim",
    keys = wrap_keys { { "<leader>u", ":Telescope undo<CR>", desc = "Undo Tree" } },
    cmd = { "Telescope undo" },
  },

  {
    "zongben/proot.nvim",
    opts = {},
    keys = wrap_keys { { "<Leader>sp", ":Proot<CR>", desc = "Search Directories" } },
    cmd = { "Proot" },
  },

  {
    "ziontee113/icon-picker.nvim",
    cmd = {
      "IconPickerInsert",
      "IconPickerNormal",
      "IconPickerYank",
      "PickEmoji",
      "PickEmojiYank",
      "PickEverything",
      "PickEverythingYank",
      "PickIcons",
      "PickIconsYank",
      "PickSymbols",
      "PickSymbolsYank",
    },
    keys = wrap_keys {
      { "<leader>se", ":PickEmoji<CR>", desc = "Icon Picker Emoji" },
      { "<leader>sE", ":PickEmojiYank emoji<CR>", desc = "Icon Picker Emoji Yank" },
      { "<leader>si", ":PickIcons<CR>", desc = "Icon Picker" },
      { "<leader>sI", ":PickIconsYank<CR>", desc = "Icon Picker Yank" },
      { "<leader>sS", ":PickSymbols<CR>", desc = "Icon Picker Unicode Symbols" },
    },
    config = function()
      require "dressing"
      require("icon-picker").setup {}
    end,
  }, -- icon picker with telescope

  {
    "tsakirist/telescope-lazy.nvim",
    keys = wrap_keys { { "<leader>sl", ":Telescope lazy<CR>", desc = "Search Lazy Plugins Doc" } },
  }, -- search lazy plugins readme file

  {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = wrap_keys {
      { "<leader>so", ":Telescope file_browser<CR>", desc = "Telescope file browser" },
      {
        "<leader>sJ",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        desc = "Telescope file browser crr",
      },
    },
  }, -- uses telescope for vim.input

  {
    "stevearc/dressing.nvim",
    lazy = true,
    config = function()
      require("dressing").setup {
        input = {
          enabled = true,
          title_pos = "center",
          start_mode = "insert",
          border = "rounded",
          relative = "win",
        },
        select = {
          enabled = true,
          telescope = require("telescope.themes").get_dropdown(),
        },
      }
    end,
  },
}
