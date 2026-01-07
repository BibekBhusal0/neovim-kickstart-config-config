local transparency_enabled = false
local wrap_keys = require "utils.wrap_keys"
local obsidian_dir = "/home/bibek/Documents/obsidian.md"

return {
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
      end,
    },
    keys = wrap_keys { { "<leader>zz", ":ZenMode<CR>", desc = "Zen Mode" } },
    cmd = { "ZenMode" },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    keys = wrap_keys {
      { "<leader>nD", ":Obsidian dailies<CR>", desc = "Obsidian Dailies" },
      { "<leader>nd", ":Obsidian today<CR>", desc = "Obsidian Today" },
      { "<leader>nj", ":Obsidian yesterday<CR>", desc = "Obsidian Yesterday" },
      { "<leader>no", ":Obsidian new<CR>", desc = "Obsidian New" },
      { "<leader>nO", ":Obsidian new_from_template<CR>", desc = "Obsidian New with Tempalte" },
      { "<leader>nf", ":Obsidian quick_switch<CR>", desc = "Obsidian Find Notes" },
      { "<leader>ns", ":Obsidian search<CR>", desc = "Obsidian Search" },
      { "<leader>nT", ":Obsidian tags<CR>", desc = "Obsidian Tags" },
      { "<leader>nt", ":Obsidian template<CR>", desc = "Obsidian Insert template" },
    },
    cmd = { "Obsidian" },
    event = {
      "BufReadPre " .. obsidian_dir .. "/*.md",
      "BufNewFile " .. obsidian_dir .. "/*.md",
    },
    opts = {
      workspaces = { { name = "main", path = obsidian_dir } },
      legacy_commands = false,
      log_level = vim.log.levels.OFF,
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
      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<A-n>",
          insert_link = "<A-i>",
        },
        tag_mappings = {
          tab_note = "<A-n>",
          insert_tag = "<A-i>",
        },
      },
      ui = { enable = false },
      attachments = {
        folder = "files",
        img_name_func = function()
          return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S")
        end,
        confirm_img_paste = true,
      },
      note_id_func = function(title)
        if title and title ~= "" then
          return title
        else
          return tostring(os.time())
        end
      end,
      callbacks = {
        enter_note = function(_, note)
          vim.keymap.set("n", "gF", ":Obsidian follow_link vsplit<cr>", {
            buffer = note.bufnr,
            desc = "Follow link vertical split",
          })
          vim.keymap.set("n", "gf", ":Obsidian follow_link<cr>", {
            buffer = note.bufnr,
            desc = "Follow link ",
          })
          vim.keymap.set("n", "<leader>nb", ":Obsidian backlinks<cr>", {
            buffer = note.bufnr,
            desc = "Backlinks",
          })
          vim.keymap.set("n", "<leader>nc", ":Obsidian toc<cr>", {
            buffer = note.bufnr,
            desc = "Table of Content",
          })
          vim.keymap.set("n", "<leader>nl", ":Obsidian links<cr>", {
            buffer = note.bufnr,
            desc = "Links",
          })
          vim.keymap.set("v", "<leader>ne", ":Obsidian extract_note<cr>", {
            buffer = note.bufnr,
            desc = "Extract note",
          })
        end,
      },
    },
  },
}
