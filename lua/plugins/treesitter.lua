local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"
local mode = { "n", "x", "o" }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup {
        ensure_installed = {
          "bash",
          "css",
          "gitignore",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = true,
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = { "ruby" },
        },
        indent = { enable = true },
        -- incremental_selection = {
        --   enable = true,
        --   keymaps = {
        --     init_selection = "<C-p>",
        --     node_incremental = "<c-p>",
        --     scope_incremental = false,
        --     node_decremental = "<bs>",
        --   },
        -- },
      }
      vim.treesitter.language.register("markdown", "vimwiki")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    keys = wrap_keys {
      { "<leader>tC", ":TSContext toggle<CR>", desc = "Toggle Treesitter Context" },
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("treesitter-context").setup { max_lines = 5 }
      map(
        "<leader><CR>",
        ':lua require("treesitter-context").go_to_context(vim.v.count1)<CR>',
        "Go to context"
      )
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    branch = "main",
    config = function()
      local keys = {
        ["/"] = "comment",
        b = "block",
        c = "class",
        f = "function",
        i = "conditional",
        j = "jsx_element",
        l = "loop",
        P = "parameter",
        r = "return",
      }
      local select_mod = require "nvim-treesitter-textobjects.select"
      local move_mod = require "nvim-treesitter-textobjects.move"

      for k, obj in pairs(keys) do
        local inner = "@" .. obj .. ".inner"
        local outer = "@" .. obj .. ".outer"

        map("i" .. k, function()
          select_mod.select_textobject(inner, "textobjects")
        end, "Select inner " .. obj, { "x", "o" })

        map("a" .. k, function()
          select_mod.select_textobject(outer, "textobjects")
        end, "Select outer " .. obj, { "x", "o" })

        map("]" .. k, function()
          move_mod.goto_next_start(outer, "textobjects")
        end, "Go to next " .. obj, mode)

        map("[" .. k, function()
          move_mod.goto_previous_start(outer, "textobjects")
        end, "Go to previous " .. obj, mode)
      end

      map("]z", function()
        move_mod.goto_next_start("@fold", "folds")
      end, "Next fold", mode)

      map("[z", function()
        move_mod.goto_previous_start("@fold", "folds")
      end, "Prev fold", mode)
    end,
  },

  {
    "BibekBhusal0/tree-hierarchy.nvim",
    dir = "~/Code/tree-hierarchy.nvim",
    keys = {
      { "m", mode = { "x" } },
      { "v", mode = { "x" } },
      { "<leader>sk", mode = { "x", "n" } },
      { "<leader>mk", mode = { "x", "n" } },
      { "<leader>mj", mode = { "x", "n" } },
      { "<leader>ms", mode = { "x", "n" } },
    },
    opts = {},
  },
}
