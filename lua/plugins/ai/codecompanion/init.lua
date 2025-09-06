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
map("<leader>ah", ":CodeCompanionHistory<CR>", "CodeCompanion History")

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = { { "ravitemer/codecompanion-history.nvim", cmd = "CodeCompanionHistory" } },
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
      require("plugins.ai.codecompanion.spinner.loader"):init()
      -- require("plugins.ai.codecompanion.spinner.visual_loader").setup()
      require("codecompanion").setup {

        display = {
          chat = {
            window = { height = 1 },
            intro_message = require("utils.icons").others.ai .. "  Ask me anything",
            show_header_separator = true,
            separator = "─",
          },
          diff = { enabled = true, provider = "mini_diff" },
        },
        opts = {
          system_prompt = require("plugins.ai.codecompanion.prompts.system").main,
        },

        strategies = {
          chat = {
            adapter = "gemini",
            model = "gemini-2.0-flash",
            keymaps = {
              send = {
                callback = function(chat)
                  vim.cmd "stopinsert"
                  chat:submit()
                  chat:add_buf_message({ role = "llm", content = "" })
                end,
                index = 1,
                description = "Send",
              },
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
            slash_commands = {
              ["save_history"] = {
                callback = function(chat)
                  local history = require("codecompanion").extensions.history
                  history.save_chat(chat)
                end,
                description = "Save Current Chat",
                opts = { contains_code = false },
              },
            },
          },
          inline = { adapter = "gemini" },
        },

        prompt_library = require "plugins.ai.codecompanion.prompts",

        extensions = {

          --[[ vectorcode = {
            opts = {
              tool_group = {
                enabled = true,
                extras = {},
                collapse = false,
              },
              tool_opts = {
                ls = {},
                vectorise = {},
                query = {
                  max_num = { chunk = -1, document = -1 },
                  default_num = { chunk = 50, document = 10 },
                  include_stderr = false,
                  use_lsp = true,
                  no_duplicate = true,
                  chunk_mode = false,
                  summarise = {
                    enabled = false,
                    adapter = nil,
                    query_augmented = true,
                  },
                },
              },
            },
          } , ]]

          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_tools = true,
              show_server_tools_in_chat = true,
              add_mcp_prefix_to_tool_names = true,
              show_result_in_chat = true,
              format_tool = nil,
              make_vars = true,
              make_slash_commands = true,
            },
          },
          ['live-edit'] = {
            callback = "plugins.ai.codecompanion.tools.live-edit",
            opts = {
              keymap_picker = "gE",
              keymap_quick = "gO",
            },
          },
          history = {
            enabled = true,
            opts = {
              keymap = "gh",
              save_chat_keymap = "<leader>sh",
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
      {
        "<leader>ag",
        function()
          vim.cmd "Git add ."
          vim.cmd "Git commit -m 'AI will change this message'"
          vim.cmd "CCGitCommit"
        end,
        desc = "Git get commit message",
      },
      { "<leader>aG", ":CCGitCommit<CR>", desc = "Git get commit message" },
    },
    cmd = { "CodeCompanionGitCommit", "CCGitCommit" },
    config = function()
      local gitcommit = require "codecompanion._extensions.gitcommit"
      require("codecompanion").register_extension("gitcommit", {
        setup = gitcommit.setup,
        exports = gitcommit.exports,
        opts = {
          languages = { "English" },

          buffer = {
            enabled = false,
            auto_generate = false,
          },

          add_slash_command = true,
          add_git_tool = true,
          enable_git_read = true,
          enable_git_edit = true,
          enable_git_bot = true,
          add_git_commands = true,
          git_tool_auto_submit_errors = true,
          git_tool_auto_submit_success = true,
          gitcommit_select_count = 100,

          use_commit_history = true,
          commit_history_count = 10,

        },
      })
    end,
  },
}
