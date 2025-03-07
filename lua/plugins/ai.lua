return {

  {
    'monkoose/neocodeium',
    cmd = { 'NeoCodeium' },
    keys = {
      { '<leader>a<leader>', ':NeoCodeium <cr>', desc = 'Codeium Start' },
      { '<leader>aT', ':lua require"neocodeium.commands".toggle(true)<cr>', desc = 'Codeium Toggle' },
      { '<leader>aC', ':NeoCodeium chat<cr>', desc = 'Codeium Chat' },
      { '<leader>ar', ':NeoCodeium restart<cr>', desc = 'Codeium Restart' },
      { '<leader>ab', ':NeoCodeium toggle_buffer<cr>', desc = 'Codeium Toggle Buffer' },
    },
    config = function()
      local neocodeium = require 'neocodeium'
      neocodeium.setup { enabled = true }
      map('<A-f>', neocodeium.accept, 'Codeium Accept', 'i')
      map('<A-w>', neoc.accept_word, 'Codeium Accept Word', 'i')
      map('<A-a>', neocodeium.accept_line, 'Codeium Accept Line', 'i')
      map('<A-e>', neocodeium.cycle_or_complete, 'Codeium Next Autocomplete', 'i')
      map('<A-r>', neocodeium.cycle_or_complete, 'Codeium Previous Autocomplete', 'i')
      map('<A-c>', neocodeium.clear, 'Codeium Clear', 'i')
    end,
  },

  {
    'olimorris/codecompanion.nvim',
    dependencies = { 'j-hui/fidget.nvim' },
    keys = {
      { '<leader>aa', ':CodeCompanionActions<cr>', desc = 'CodeCompanion Actions', mode = { 'n', 'v' } },
      { '<leader>ac', ':CodeCompanionChat toggle<cr>', desc = 'CodeCompanion Chat' },
      { '<leader>ac', ':CodeCompanionChat Add<cr>', desc = 'CodeCompanion Chat', mode = { 'v' } },
      { '<leader>ae', ':CodeCompanion /error<cr>', desc = 'CodeCompanion Check For Error', mode = { 'v' } },
      { '<leader>af', ':CodeCompanion /fix<cr>', desc = 'CodeCompanion Fix Errors', mode = { 'v' } },
      { '<leader>aR', ':CodeCompanion /readable<cr>', desc = 'CodeCompanion Make Code Readable', mode = { 'v' } },
      { '<leader>ag', ':CodeCompanion /commit<cr>', desc = 'CodeCompanion get commit message' },
      {
        '<leader>aG',
        function()
          vim.cmd 'Git add .'
          vim.cmd 'CodeCompanion /commit'
        end,
        desc = 'Commit changes and get commit message',
      },
      {
        '<leader>ai',
        function()
          require 'utils.input'('  Command to AI  ', function(text)
            vim.cmd 'normal! gv'
            vim.cmd('CodeCompanion /buffer ' .. text)
          end, '', 80)
        end,
        desc = 'CodeCompanion Inline command',
        mode = { 'v' },
      },
    },
    config = function()
      local export = function(context)
        return string.format([[You are a export %s developer.]], context.filetype)
      end

      require('utils.loader'):init()
      require('codecompanion').setup {
        strategies = {
          chat = { adapter = 'gemini' },
          inline = { adapter = 'gemini' },
        },
        prompt_library = require 'utils.prompts',
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
