local wrap_keys = require "utils.wrap_keys"

return {
  {
    "kylechui/nvim-surround",
    keys = {
      { "ys", mode = { "n", "o", "x" }, desc = "Surround Text" },
      { "ds", mode = { "n", "o", "x" }, desc = "Surround Delete" },
      { "cs", mode = { "n", "o", "x" }, desc = "Surround Change" },
    },
    opts = {},
  }, -- change brackets, quotes and surrounds

  {
    "echasnovski/mini.trailspace",
    keys = wrap_keys {
      { "<leader>tw", ':lua require("mini.trailspace").trim() <CR>', desc = "Trim Whitespace" },
    },
  }, -- Simple ways to trail whitespace useful when formatter is not working

  {
    "nacro90/numb.nvim",
    opts = {},
    keys = {
      { "0", mode = "c" },
      { "1", mode = "c" },
      { "2", mode = "c" },
      { "3", mode = "c" },
      { "4", mode = "c" },
      { "5", mode = "c" },
      { "6", mode = "c" },
      { "7", mode = "c" },
      { "8", mode = "c" },
      { "9", mode = "c" },
    },
  }, -- Preview of line from command mode

  {
    "windwp/nvim-autopairs",
    keys = {
      { "{", mode = { "i" } },
      { "[", mode = { "i" } },
      { "(", mode = { "i" } },
      { '"', mode = { "i" } },
      { "'", mode = { "i" } },
      { "`", mode = { "i" } },
      { "}", mode = { "i" } },
      { "]", mode = { "i" } },
      { ")", mode = { "i" } },
    },
    config = true,
  }, -- Autoclose parentheses, brackets, quotes, etc. also work on command mode

  {
    "mg979/vim-visual-multi",
    keys = { "<C-n>", "<C-Up>", "<C-Down>", "<S-Left>", "<S-Right>" },
    config = function()
      local hlslens = require "hlslens"
      if hlslens then
        local overrideLens = function(render, posList, nearest, idx, relIdx)
          local _ = relIdx
          local lnum, col = unpack(posList[idx])
          local text, chunks
          if nearest then
            text = ("[%d/%d]"):format(idx, #posList)
            chunks = { { " ", "Ignore" }, { text, "VM_Extend" } }
          else
            text = ("[%d]"):format(idx)
            chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
        local lensBak
        local config = require "hlslens.config"
        local gid = vim.api.nvim_create_augroup("VMlens", {})
        vim.api.nvim_create_autocmd("User", {
          pattern = { "visual_multi_start", "visual_multi_exit" },
          group = gid,
          callback = function(ev)
            if ev.match == "visual_multi_start" then
              lensBak = config.override_lens
              config.override_lens = overrideLens
            else
              config.override_lens = lensBak
            end
            hlslens.start()
          end,
        })
      end
    end,
  }, -- multi line editing

  {
    "nguyenvukhang/nvim-toggler",
    keys = wrap_keys {
      { "<leader>tt", ':lua require("nvim-toggler").toggle() <CR>', desc = "Toggle Value" },
    },
    config = function()
      require("nvim-toggler").setup {
        inverses = {
          ["neo-vim"] = "vs-code",
          ["0"] = "1",
          show = "hide",
          best = "worst",
          pre_defer = "post_defer",
        },
        remove_default_keybinds = true,
      }
    end,
  }, -- Toggle between true and false ; more

  {
    "johmsalas/text-case.nvim",
    opts = {},
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },

  {
    "echasnovski/mini.operators",
    keys = {
      { "g=", mode = { "n", "o", "x" }, desc = "Minit Evaluate" },
      { "gm", mode = { "n", "o", "x" }, desc = "Minit Multiply" },
      { "<leader>rl", mode = { "n", "o", "x" }, desc = "Minit Replace" },
      { "gs", mode = { "n", "o", "x" }, desc = "Minit Sort" },
      { "gx", mode = { "n", "o", "x" }, desc = "Minit Exchange" },
    },
    opts = {replace = {prefix = '<leader>rl' }},
  }, -- sorting with motion

  {
    "Wansmer/treesj",
    keys = wrap_keys {
      { "gi", ":TSJToggle<CR>", desc = "Toggle split object under cursor" },
      { "gj", ":TSJJoin<CR>", desc = "Join the object under cursor" },
      { "gk", ":TSJSplit<CR>", desc = "Split the object under cursor" },
    },
    opts = { use_default_keymaps = false, max_join_length = 10000 },
  }, -- advanced join and split

  {
    "abecodes/tabout.nvim",
    event = "InsertCharPre",
    opts = {},
  }, -- easy jumping between start and end brackets in insert mode

  {
    "y3owk1n/time-machine.nvim",
    cmd = { "TimeMachineToggle", "TimeMachinePurgeBuffer", "TimeMachinePurgeAll" },
    opts = {},
    version = "*",
    keys = wrap_keys {
      { "<leader>tm", ":TimeMachineToggle<CR>", desc = "Time Machine Toggle Tree" },
      { "<leader>tM", ":TimeMachinePurgeBuffer<CR>", desc = "Time Machine Purge current" },
      { "<leader>tX", ":TimeMachinePurgeAll<CR>", desc = "Time Machine Purge all" },
      { "<leader>u", ":TimeMachineToggle<CR>", desc = "Time Machine Toggle Tree" },
    },
  }, -- similar to undo tree
}
