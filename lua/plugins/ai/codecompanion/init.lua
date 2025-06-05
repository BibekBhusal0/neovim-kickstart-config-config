local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

local inline_command = function()
  local select_command = "normal! gv"
  local initial_mode = vim.api.nvim_get_mode().mode
  local mark = "p"

  if initial_mode == "n" then
    vim.cmd ( "normal! m" .. mark )
    select_command = "normal! ggVG"
  end

  local input_callback = function(text)
    vim.cmd(select_command)
    vim.cmd("CodeCompanion #buffer " .. text)
    vim.defer_fn(function()
      vim.api.nvim_feedkeys("", "n", false)
      if initial_mode == "n" then
        vim.cmd("normal! `" .. mark)
      end
    end, 2)
  end
  require "utils.input"(
    "  Command to AI  ",
    input_callback,
    "",
    80,
    require("utils.icons").others.ai .. "  "
  )
end


local function actions()
  require("codecompanion").actions {
    provider = {
      name = "telescope",
      opts = require("telescope.themes").get_dropdown { previewer = false },
    },
  }
end

map("<leader>aa", actions, "CodeCompanion Inline command", { "v", "n" })
map("<leader>ai", inline_command, "CodeCompanion Inline command", { "v", "n" })

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "ravitemer/codecompanion-history.nvim" },
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = wrap_keys {
      { "<leader>ac", ":CodeCompanionChat toggle<CR>", desc = "CodeCompanion Chat" },
      {
        "<leader>ac",
        ":CodeCompanionChat Add<CR>",
        desc = "CodeCompanion Chat",
        mode = { "v" },
      },
      {
        "<leader>ae",
        ":CodeCompanion /explain<CR>",
        desc = "CodeCompanion Explain",
        mode = { "v" },
      },
      {
        "<leader>an",
        ":CodeCompanion /new<CR>",
        desc = "CodeCompanion New",
        mode = { "v" },
      },
      {
        "<leader>af",
        ":CodeCompanion /fix<CR>",
        desc = "CodeCompanion Fix Errors",
        mode = { "v" },
      },
      {
        "<leader>al",
        ":CodeCompanion /lsp<CR>",
        desc = "CodeCompanion Explain LSP Diagnostics",
        mode = { "v" },
      },
      {
        "<leader>ar",
        ":CodeCompanion /readable<CR>",
        desc = "CodeCompanion Make Code Readable",
        mode = { "v" },
      },
      {
        "<leader>aj",
        ":CodeCompanion /straight<CR>",
        desc = "CodeCompanion straight forward coder",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        ":CodeCompanion /paste<CR>",
        desc = "CodeCompanion Smart paste",
        mode = { "n", "v" },
      },
      {
        "<leader>an",
        ':lua require("codecompanion.strategies.chat").new({})<CR>',
        desc = "CodeCompanion start new chat",
      },
    },

    config = function()
      require("plugins.ai.loader"):init()
      require("codecompanion").setup {

        display = {
          chat = {
            window = { height = 1 },
            intro_message = require("utils.icons").others.ai .. "  Ask me anything",
          },
          diff = { enabled = true, provider = "mini_diff" },
        },
        opts = {
          system_prompt = require("plugins.ai.codecompanion.prompts.system").main,
        },

        strategies = {
          chat = {
            adapter = "gemini",
            keymaps = {
              next_chat = {
                modes = { n = ">" },
                callback = "keymaps.next_chat",
                description = "Next Chat",
              },
              previous_chat = {
                modes = { n = "<" },
                callback = "keymaps.previous_chat",
                description = "Previous Chat",
              },
              next_header = {
                modes = { n = "]h" },
                callback = "keymaps.next_header",
                description = "Next Header",
              },
              previous_header = {
                modes = { n = "[h" },
                callback = "keymaps.previous_header",
                description = "Previous Header",
              },
            },
          },
          inline = { adapter = "gemini" },
        },

        prompt_library = require "plugins.ai.codecompanion.prompts",
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              name = "gemini",
              schema = { model = { default = "gemini-2.0-flash" } },
            })
          end,
        },

        extensions = {
          custom_tools = { callback = "plugins.ai.codecompanion.tools" },
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true,
              make_vars = true,
              make_slash_commands = true,
            },
          },
          history = {
            enabled = true,
            opts = {
              keymap = "gh",
              save_chat_keymap = "sc",
              auto_save = false,
              expiration_days = 0,
              picker = "telescope",
              auto_generate_title = true,
              title_generation_opts = {
                adapter = "gemini",
                model = "gemini-1.5-flash",
                refresh_every_n_prompts = 0,
                max_refreshes = 3,
              },
              continue_last_chat = false,
              delete_on_clearing_chat = false,
              enable_logging = false,
            },
          },
        },
      }
    end,
  },

  {
    "jinzhongjia/codecompanion-gitcommit.nvim",
    keys = wrap_keys {
      { "<leader>ag", ":CCGitCommit<CR>", desc = "Git get commit message" },
    },
    cmd = { "CodeCompanionGitCommit", "CCGitCommit" },
    config = function()
      require("codecompanion").setup {
        extensions = {
          gitcommit = {
            callback = "codecompanion._extensions.gitcommit",
            opts = {
              add_slash_command = false,
              buffer = { enabled = false, keymap = "<leader>gc" },
            },
          },
        },
      }
    end,
  },
}
