local map = require 'utils.map'

return {
  {
    'chrisgrieser/nvim-chainsaw',
    keys = {
      { '<leader>lv', ':lua require("chainsaw").variableLog()<cr>', desc = 'Log Variable' },
      { '<leader>lp', ':lua require("chainsaw").objectLog()<cr>', desc = 'Log Object' },
      { '<leader>lP', ':lua require("chainsaw").typeLog()<cr>', desc = 'Log Type' },
    },
    opts = { marker = '🌟', visuals = { icon = '🌟' } },
  }, -- Easy printing

  {
    'Weissle/persistent-breakpoints.nvim',
    opts = {},
    keys = {
      {
        '<leader>db',
        ":lua require('persistent-breakpoints.api').load_breakpoints()<cr>:PBToggleBreakpoint<cr>",
        desc = 'Debuger Toggle BreakPoint',
      },
      {
        '<leader>dC',
        ":lua require('persistent-breakpoints.api').load_breakpoints()<cr>:PBSetConditionalBreakpoint<cr>",
        desc = 'Debuger Toggle Conditional BreakPoint',
      },
      {
        '<leader>dl',
        ":lua require('persistent-breakpoints.api').load_breakpoints()<cr>:PBSetLogPoint<cr>",
        desc = 'Debuger Toggle Log BreakPoint',
      },
      { '<leader>dB', ':PBClearAllBreakpoints<cr>', desc = 'Debuger Clear All BreakPoint' },
    },
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'mfussenegger/nvim-dap-python',
    },
    keys = { { '<leader>dc', ":lua require('dap').continue() <cr>", desc = 'Debugger Continue' } },

    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      local mason = vim.fn.stdpath 'data' .. '/mason/packages'
      require('dap-python').setup(mason .. '/debugpy/venv/Scripts/python.exe')
      require('nvim-dap-virtual-text').setup()

      dapui.setup {
        icons = { collapsed = '', current_frame = '', expanded = '' },
        layouts = {
          {
            elements = {
              { id = 'repl', size = 0.1 },
              { id = 'console', size = 0.3 },
              { id = 'scopes', size = 0.45 },
              { id = 'stacks', size = 0.15 },
            },
            position = 'left',
            size = 40,
          },
          {
            elements = {
              { id = 'breakpoints', size = 0.5 },
              { id = 'watches', size = 0.5 },
            },
            position = 'bottom',
            size = 10,
          },
        },
      }

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { mason .. '/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
        },
      }

      local ts_config = {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        runtimeExecutable = 'deno',
        runtimeArgs = {
          'run',
          '--inspect-wait',
          '--allow-all',
        },
        program = '${file}',
        cwd = '${workspaceFolder}',
        attachSimplePort = 9229,
      }

      dap.configurations.typescript = { ts_config }
      dap.configurations.javascript = { ts_config }

      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close

      map('<leader>dt', ':lua require("nvim-dap-virtual-text").toggle()<cr>', 'Debugger Toggle Virtual Text')
      map('<leader>dT', dapui.toggle, 'Debugger UI Toggle')
      map('<leader>ds', ':DapTerminate<cr>', 'Debugger Stop')
      map('<leader>do', dap.step_over, 'Debugger Step Over')
      map('<leader>dO', dap.step_out, 'Debugger Step Out')
      map('<leader>di', dap.step_into, 'Debugger Step Into')
    end,
  },
}
