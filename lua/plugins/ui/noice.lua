local map = require "utils.map"

return {
  "folke/noice.nvim",
  enabled = true,
  -- event = { "BufReadPost", "BufNewFile", "CmdLineEnter" },
  event = { "VeryLazy" },
  dependencies = {
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "wrapped-compact",
        stages = "slide",
        max_width = 35,
        max_height = 50,
        top_down = false,
      },
    },
  },

  config = function()
    local noice = require "noice"
    map("<A-j>", function()
      noice.redirect(vim.fn.getcmdline())
    end, "Redirect Cmdline", "c")
    map("<leader>Nr", ":Noice dismiss<CR>", "Noice remove")
    map("<leader>Nl", ":Noice last<CR>", "Noice last")
    map("<leader>nh", ":Noice history<CR>", "Noice history")
    map("<leader>Ns", ":Telescope noice<CR>", "Noice Telescope")
    map("<leader>fn", ":Telescope noice<CR>", "Noice Telescope")
    map("<leader>NS", ":Telescope notify<CR>", "Notify Telescope")
    map("<leader>fN", ":Telescope notify<CR>", "Notify Telescope")
    map("<leader>Nt", function()
      local running = require("noice.config")._running
      if running then
        noice.disable()
      else
        noice.enable()
      end
    end, "Toggle Noice")

    noice.setup {
      level = { icons = require("utils.icons").diagnostics },
      messages = { view_search = false },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = false },
        hover = { enabled = false, silent = true },
      },
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
      cmdline = {
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          Visual = { pattern = "^:'<,'>", icon = ">", lang = "vim" },
          Telescope = { pattern = "^:Telescope ", icon = "" },
          Trouble = { pattern = "^:Trouble ", icon = "" },
          gitsigns = { pattern = "^:Gitsigns ", icon = require("utils.icons").others.git },
          git = { pattern = "^:Git ", icon = require("utils.icons").others.github },
          ai = { pattern = "^:CodeCompanion ", icon = require("utils.icons").others.ai },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
          input = { view = "cmdline_input", icon = "󰥻 " },
        },
      },
      commands = {
        history = { view = "popup" },
        last = { view = "notify" },
        all = { view = "popup" },
      },
    }
  end,
}
