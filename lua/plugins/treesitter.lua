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
      { "<leader>tC", ":TSContextToggle<CR>", desc = "Toggle Treesitter Context" },
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
    "ziontee113/syntax-tree-surfer",
    opts = {},
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
      local keymaps = {}
      local goto_next_start = {}
      local goto_previous_start = {}
      -- local swap_next = {}
      -- local swap_previous = {}
      -- local goto_next_end = {}
      -- local goto_previous_end = {}

      for k, v in pairs(keys) do
        keymaps["i" .. k] = { query = "@" .. v .. ".inner", desc = "Inner " .. v }
        keymaps["a" .. k] = { query = "@" .. v .. ".outer", desc = "Outer " .. v }
        goto_next_start["]" .. k] = { query = "@" .. v .. ".outer", desc = "Jump Next " .. v }
        goto_previous_start["[" .. k] =
          { query = "@" .. v .. ".outer", desc = "Jump Previous " .. v }
        -- swap_next['<leader>m' .. k] = { query = '@' .. v .. '.outer', desc = 'Swap Next ' .. v }
        -- swap_previous['<leader>M' .. k] = { query = '@' .. v .. '.outer', desc = 'Swap Previous ' .. v }
        -- goto_previous_end['(' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Previous ' .. v .. ' End' }
        -- goto_next_end[')' .. k] = { query = '@' .. v .. '.outer', desc = 'Jump Next ' .. v .. ' End' }
      end
      goto_next_start["]z"] = { query = "@fold", query_group = "folds", desc = "Jump next fold" }
      goto_next_start["[z"] = { query = "@fold", query_group = "folds", desc = "Prev next fold" }

      require("nvim-treesitter").setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = keymaps,
          },
          swap = {
            -- enable = true,
            -- swap_next = swap_next,
            -- swap_previous = swap_previous,
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = goto_next_start,
            goto_previous_start = goto_previous_start,
            -- goto_next_end = goto_next_end,
            -- goto_previous_end = goto_previous_end,
          },
        },
      }
    end,
  },
}
