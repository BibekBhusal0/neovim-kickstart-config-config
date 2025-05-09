local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

local inline_command = function()
  require "utils.input"("  Command to AI  ", function(text)
    vim.cmd "normal! gv"
    vim.cmd(
      "CodeCompanion #buffer "
        .. text
        .. " **Make sure to give complete code and only make changes according to commands change nothing else, If you are not able to make changes just give code as it is**"
    )
  end, "", 80, require("utils.icons").others.ai .. "  ")
end

local commit_callback = function()
  local executed = false
  if not executed then
    local chat = require("codecompanion.strategies.chat").last_chat()
    local messages = chat.agents.messages
    local last_message = messages[#messages].content
    if type(last_message) == "string" and string.len(last_message) < 100 then
      require "utils.input"(
        " Commit Message ",
        function(text)
          vim.cmd("Git commit -a -m '" .. text .. "'")
        end,
        last_message,
        nil,
        require("utils.icons").others.ai .. " " .. require("utils.icons").others.github .. "  "
      )
    end
    executed = true
  end
end

local commit_with_message = function()
  vim.cmd "Git add ."
  local m = require "plugins.ai.diff"()
  if not m.ok then
    vim.notify(m.message, vim.log.levels.WARN)
    return
  end
  vim.cmd "CodeCompanion /commit"
  local au_group = vim.api.nvim_create_augroup("codecompanion_commit", { clear = true })
  vim.api.nvim_create_autocmd({ "User" }, {
    group = au_group,
    pattern = "CodeCompanionRequestFinished",
    callback = commit_callback,
  })
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
map("<leader>ag", commit_with_message, "Add changes and get commit message")
map("<leader>ai", inline_command, "CodeCompanion Inline command", { "v" })

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = wrap_keys {
      { "<leader>ac", ":CodeCompanionChat toggle<CR>", desc = "CodeCompanion Chat" },
      { "<leader>ac", ":CodeCompanionChat Add<CR>", desc = "CodeCompanion Chat", mode = { "v" } },
      {
        "<leader>ae",
        ":CodeCompanion /explain<CR>",
        desc = "CodeCompanion Explain",
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
      { "<leader>aG", ":CodeCompanion /commit<CR>", desc = "CodeCompanion get commit message" },
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

        strategies = {
          chat = {
            adapter = "gemini",
            tools = require "plugins.ai.codecompanion.tools",
            keymaps = {
              next_chat = {
                modes = { n = ">" },
                index = 11,
                callback = "keymaps.next_chat",
                description = "Next Chat",
              },
              previous_chat = {
                modes = { n = "<" },
                index = 12,
                callback = "keymaps.previous_chat",
                description = "Previous Chat",
              },
              next_header = {
                modes = { n = "]r" },
                index = 13,
                callback = "keymaps.next_header",
                description = "Next Header",
              },
              previous_header = {
                modes = { n = "[r" },
                index = 14,
                callback = "keymaps.previous_header",
                description = "Previous Header",
              },
            },
          },
          inline = { adapter = "gemini" },
        },

        prompt_library = require "plugins.ai.codecompanion.prompts",
        adapters = {
          gemini = "gemini",
          opts = { show_defaults = false },
        },
      }
    end,
  },

  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require "mini.diff"
      diff.setup { source = diff.gen_source.none() }
    end,
  },
}
