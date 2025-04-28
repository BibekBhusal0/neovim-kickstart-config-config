local transparency_enabled = false
local wrap_keys = require "utils.wrap_keys"
local obsidian_dir = "~/OneDrive - dafdodsakjf/Documents/Obsidian Vault"
vim.opt.conceallevel = 1

return {
  {
    "quentingruber/pomodoro.nvim",
    cmd = {
      "PomodoroDelayBreak",
      "PomodoroForceBreak",
      "PomodoroSkipBreak",
      "PomodoroStart",
      "PomodoroStop",
      "PomodoroUI",
    },
    keys = wrap_keys {
      { "<Leader>pb", ":PomodoroForceBreak<CR>", desc = "Pomodoro Force Break" },
      { "<Leader>pB", ":PomodoroSkipBreak<CR>", desc = "Pomodoro Skip Break" },
      { "<Leader>pd", ":PomodoroDelayBreak<CR>", desc = "Pomodoro Delay Break" },
      { "<leader>ps", ":PomodoroStart<CR>", desc = "Pomodoro Start" },
      { "<Leader>pS", ":PomodoroStop<CR>", desc = "Pomodoro Stop" },
      { "<Leader>pu", ":PomodoroUI<CR>", desc = "Pomodoro UI" },
    },
    opts = {
      start_at_launch = false,
      work_duration = 25,
      break_duration = 5,
      delay_duration = 1,
      long_break_duration = 15,
      breaks_before_long = 4,
    },
  }, -- Simple pomodoro timer

  {
    "backdround/global-note.nvim",
    keys = wrap_keys {
      { "<leader>ng", ":GlobalNote<CR>", desc = "Global Note" },
      { "<leader>np", ":ProjectNote<CR>", desc = "Project Note" },
    },
    config = function()
      local gloabl_note = require "global-note"
      local get_project_name = function()
        local project_directory, err = vim.loop.cwd()
        if project_directory == nil then
          vim.notify(err, vim.log.levels.WARN)
          return nil
        end
        local project_name = vim.fs.basename(project_directory)
        if project_name == nil then
          vim.notify("Unable to get the project name", vim.log.levels.WARN)
          return nil
        end
        return project_name
      end
      gloabl_note.setup {
        additional_presets = {
          project_local = {
            command_name = "ProjectNote",
            filename = function()
              return get_project_name() .. ".md"
            end,
            title = "Project note",
          },
        },
      }
    end,
  }, -- note taking

  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        backdrop = 1,
        width = 1,
        height = 1,
        options = {
          signcolumn = "yes",
          number = true,
          relativenumber = true,
        },
      },
      plugins = {
        gitsigns = { enabled = false },
        todo = { enabled = false },
        twilight = { enabled = false },
      },

      on_open = function()
        pcall(function()
          require("tiny-glimmer").disable()
        end)
        pcall(function()
          require("noice").disable()
        end)
        pcall(function()
          require("smear_cursor").enabled = false
        end)
        vim.opt.fillchars =
          { fold = " ", eob = " ", foldopen = "", foldsep = " ", foldclose = "" }
        transparency_enabled = require("utils.transparency").bg_transparent
        require("utils.transparency").disable_transparency "#000000"
        vim.cmd "PomodoroSkipBreak"
      end,

      on_close = function()
        pcall(function()
          require("tiny-glimmer").enable()
        end)
        pcall(function()
          require("noice").enable()
        end)
        pcall(function()
          require("smear_cursor").enabled = true
        end)
        if transparency_enabled then
          require("utils.transparency").enable_transparency()
        else
          require("utils.transparency").disable_transparency()
        end
        vim.cmd "PomodoroUI"
      end,
    },
    keys = wrap_keys { { "<leader>zz", ":ZenMode<CR>", desc = "Zen Mode" } },
    cmd = { "ZenMode" },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    keys = wrap_keys {
      { "<leader>nc", ":Obsidian toc<CR>", desc = "Obsidian Table of contents" },
      { "<leader>nD", ":Obsidian dailies<CR>", desc = "Obsidian Dailies" },
      { "<leader>nb", ":Obsidian backlinks<CR>", desc = "Obsidian Backlinks" },
      { "<leader>nd", ":Obsidian today<CR>", desc = "Obsidian Today" },
      { "<leader>nj", ":Obsidian yesterday<CR>", desc = "Obsidian Yesterday" },
      { "<leader>nk", ":Obsidian tomorrow<CR>", desc = "Obsidian Tomorrow" },
      { "<leader>no", ":Obsidian new<CR>", desc = "Obsidian New" },
      { "<leader>nO", ":Obsidian new_from_template<CR>", desc = "Obsidian New with Tempalte" },
      { "<leader>nq", ":Obsidian quick_switch<CR>", desc = "Obsidian Quick Switch" },
      { "<leader>ns", ":Obsidian search<CR>", desc = "Obsidian Search" },
      { "<leader>nT", ":Obsidian tags<CR>", desc = "Obsidian Tags" },
      { "<leader>nl", ":Obsidian links<CR>", desc = "Obsidian Links" },
      { "<leader>nt", ":Obsidian template<CR>", desc = "Obsidian Insert template" },
      { "<leader>nv", ":Obsidian followlink vsplit<CR>", desc = "Obsidian Open in split" },
    },
    cmd = { "Obsidian" },
    event = {
      "BufReadPre " .. obsidian_dir .. "/*.md",
      "BufNewFile " .. obsidian_dir .. "/*.md",
    },
    opts = {
      workspaces = { { name = "main", path = obsidian_dir } },
      log_level = vim.log.levels.OFF,
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      templates = {
        folder = "templates/main",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
      daily_notes = {
        folder = "1 raw/daily",
        date_format = "%Y/%m/%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-note" },
        template = "daily",
      },
      ui = {
        enabled = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["-"] = { char = "󰥔", hl_group = "ObsidianImportant" },
          ["x"] = { char = "󰱒", hl_group = "ObsidianDone" },
        },
      },
    },
  },
}
