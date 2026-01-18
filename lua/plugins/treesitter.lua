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
    -- FIX: not working for latest version of treesitter need replacement
    "ziontee113/syntax-tree-surfer",
    opts = {},
    enabled = false,
    keys = {
      { "<A-j>", "<cmd>STSSwapNextVisual<CR>", desc = "Swap Next", mode = "x" },
      { "<A-k>", "<cmd>STSSwapPrevVisual<CR>", desc = "Swap Previous", mode = "x" },
      { "gS", "<cmd>STSSwapOrHold<CR>", desc = "Swap Or Hold Node" },
      { "gS", "<cmd>STSSwapOrHoldVisual<CR>", desc = "Swap Or Hold Node", mode = "x" },
      { "m", "<cmd>STSSelectParentNode<CR>", desc = "Select Parent", mode = "x" },
      { "t", "<cmd>STSSelectChildNode<CR>", desc = "Select Child", mode = "x" },
      { "vD", "<cmd>STSSwapCurrentNodeNextNormal<CR>", desc = "Swap Node Next" },
      { "vd", "<cmd>STSSwapDownNormal<CR>", desc = "Swap Node Down" },
      { "vn", "<cmd>STSSelectCurrentNode<CR>", desc = "Select Current Node" },
      { "vU", "<cmd>STSSwapCurrentNodePrevNormal<CR>", desc = "Swap Node Previous" },
      { "vu", "<cmd>STSSwapUpNormal<CR>", desc = "Swap Node Up" },
      { "zh", "<cmd>STSSelectParentNode<CR>", desc = "Select Parent", mode = "x" },
      { "zh", "v<cmd>STSSelectParentNode<CR>", desc = "Select Parent" },
      { "zj", "<cmd>STSSelectNextSiblingNode<CR>", desc = "Select Next Sibling", mode = "x" },
      { "zj", "v<cmd>STSSelectNextSiblingNode<CR>", desc = "Select Next Sibling" },
      { "zk", "<cmd>STSSelectPrevSiblingNode<CR>", desc = "Select Previous Sibling", mode = "x" },
      { "zk", "v<cmd>STSSelectPrevSiblingNode<CR>", desc = "Select Previous Sibling" },
      { "zl", "<cmd>STSSelectChildNode<CR>", desc = "Select Child", mode = "x" },
      { "zl", "v<cmd>STSSelectChildNode<CR>", desc = "Select Child" },
      {
        "<leader>j",
        function()
          require("syntax-tree-surfer").targeted_jump {
            "start_tag",
            "arrow_function",
            "function_definition",
            "jsx_element",
            "jsx_self_closing_element",
            "function_declaration",
            "return_statement",
            "if_statement",
            "else_clause",
            "else_statement",
            "elseif_statement",
            "for_statement",
            "while_statement",
            "switch_statement",
          }
        end,
        desc = "Jump to important",
      },
      {
        "<leader>J",
        function()
          require("syntax-tree-surfer").targeted_jump {
            "import_statement",
            "start_tag",
            "end_tag",
            "open_tag",
            "close_tag",
            "jsx_closing_element",
            "jsx_opening_element",
            "jsx_self_closing_element",
            "function_call",
            "variable_declaration",
            "lexical_declaration",
          }
        end,
        desc = "Jump",
      },
    },
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
