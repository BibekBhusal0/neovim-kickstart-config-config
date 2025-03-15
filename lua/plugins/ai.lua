local wrap_keys = require 'utils.wrap_keys'
local map = require 'utils.map'

local commit_with_message = function()
  vim.cmd 'Git add .'

  local m = require 'utils.diff'()
  if not m.ok then
    print(m.message)
    return
  end

  vim.cmd 'CodeCompanion /commit'
  local executed = false

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequestFinished',
    callback = function()
      if not executed then
        local chat = require('codecompanion.strategies.chat').last_chat()
        local messages = chat.agents.messages
        local last_message = messages[#messages].content
        if type(last_message) == 'string' and string.len(last_message) < 100 then
          require 'utils.input'(' Commit Message ', function(text)
            vim.cmd("Git commit -a -m '" .. text .. "'")
          end, last_message, nil, require('utils.icons').others.ai .. ' ' .. require('utils.icons').others.github .. '  ')
        end
        executed = true
      end
    end,
  })
end

local inline_command = function()
  require 'utils.input'('  Command to AI  ', function(text)
    vim.cmd 'normal! gv'
    vim.cmd('CodeCompanion /buffer ' .. text)
  end, '', 80, require('utils.icons').others.ai .. '  ')
end

return {

  {
    'monkoose/neocodeium',
    cmd = { 'NeoCodeium' },
    keys = wrap_keys {
      { '<leader>a<leader>', ':NeoCodeium enable<CR>', desc = 'Codeium Start' },
      { '<leader>aT', ':lua require"neocodeium.commands".toggle(true)<CR>', desc = 'Codeium Toggle' },
      { '<leader>aC', ':NeoCodeium chat<CR>', desc = 'Codeium Chat' },
      { '<leader>ar', ':NeoCodeium restart<CR>', desc = 'Codeium Restart' },
      { '<leader>ab', ':NeoCodeium toggle_buffer<CR>', desc = 'Codeium Toggle Buffer' },
    },
    config = function()
      local neocodeium = require 'neocodeium'
      neocodeium.setup { enabled = true }
      map('<A-f>', neocodeium.accept, 'Codeium Accept', 'i')
      map('<A-w>', neocodeium.accept_word, 'Codeium Accept Word', 'i')
      map('<A-a>', neocodeium.accept_line, 'Codeium Accept Line', 'i')
      map('<A-e>', neocodeium.cycle_or_complete, 'Codeium Next Autocomplete', 'i')
      map('<A-r>', neocodeium.cycle_or_complete, 'Codeium Previous Autocomplete', 'i')
      map('<A-c>', neocodeium.clear, 'Codeium Clear', 'i')
    end,
  },

  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' },
    keys = wrap_keys {
      { '<leader>aa', ':CodeCompanionActions<CR>', desc = 'CodeCompanion Actions', mode = { 'n', 'v' } },
      { '<leader>ac', ':CodeCompanionChat toggle<CR>', desc = 'CodeCompanion Chat' },
      { '<leader>ac', ':CodeCompanionChat Add<CR>', desc = 'CodeCompanion Chat', mode = { 'v' } },
      { '<leader>ae', ':CodeCompanion /explain<CR>', desc = 'CodeCompanion Explain', mode = { 'v' } },
      { '<leader>af', ':CodeCompanion /fix<CR>', desc = 'CodeCompanion Fix Errors', mode = { 'v' } },
      { '<leader>al', ':CodeCompanion /lsp<CR>', desc = 'CodeCompanion Explain LSP Diagnostics', mode = { 'v' } },
      { '<leader>ar', ':CodeCompanion /readable<CR>', desc = 'CodeCompanion Make Code Readable', mode = { 'v' } },
      { '<leader>aG', ':CodeCompanion /commit<CR>', desc = 'CodeCompanion get commit message' },
      { '<leader>aj', ':CodeCompanion /straight<CR>', desc = 'CodeCompanion straight forward coder', mode = { 'n', 'v' } },
      { '<leader>an', ':lua require("codecompanion.strategies.chat").new({})<CR>', desc = 'CodeCompanion start new chat' },
      { '<leader>ag', commit_with_message, desc = 'Add changes and get commit message' },
      { '<leader>ai', inline_command, desc = 'CodeCompanion Inline command', mode = { 'v' } },
    },
    config = function()
      require('utils.loader'):init()
      require('codecompanion').setup {
        display = {
          chat = {
            window = { height = 1 },
            intro_message = '   Ask me anything',
          },
          diff = { enabled = true },
        },
        strategies = {
          chat = {
            adapter = 'gemini',
            keymaps = {
              next_chat = { modes = { n = '>' }, index = 11, callback = 'keymaps.next_chat', description = 'Next Chat' },
              previous_chat = { modes = { n = '<' }, index = 12, callback = 'keymaps.previous_chat', description = 'Previous Chat' },
              next_header = { modes = { n = ']r' }, index = 13, callback = 'keymaps.next_header', description = 'Next Header' },
              previous_header = { modes = { n = '[r' }, index = 14, callback = 'keymaps.previous_header', description = 'Previous Header' },
            },
          },
          inline = { adapter = 'gemini' },
        },
        prompt_library = require 'utils.prompts',
        adapters = {
          gemini = 'gemini',
          opts = { show_defaults = false },
        },
      }
    end,
  },

  -- {
  --   'yetone/avante.nvim',
  --   provider = 'gemini',
  --   dual_boost = {
  --     enabled = false,
  --     first_provider = 'openai',
  --     second_provider = 'claude',
  --     prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
  --     timeout = 60000, -- Timeout in milliseconds
  --   },
  --   behaviour = {
  --     auto_suggestions = false, -- Experimental stage
  --     auto_set_highlight_group = true,
  --     auto_set_keymaps = false,
  --     auto_apply_diff_after_generation = false,
  --     support_paste_from_clipboard = false,
  --     minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
  --     enable_token_counting = true, -- Whether to enable token counting. Default to true.
  --     enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
  --   },
  -- },
}
