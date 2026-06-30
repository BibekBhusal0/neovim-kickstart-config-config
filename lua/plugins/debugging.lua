local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

map("gp", "<Nop>")
return {
  {
    "andrewferrier/debugprint.nvim",
    version = "*",
    opts = {
      keymaps = {
        normal = {
          plain_below = "gpJ",
          plain_above = "gpK",
          variable_below = "gpj",
          variable_above = "gpk",
          variable_below_alwaysprompt = "",
          variable_above_alwaysprompt = "",
          surround_plain = "gpS",
          surround_variable = "gps",
          surround_variable_alwaysprompt = "",
          textobj_below = "gpo",
          textobj_above = "gpO",
          textobj_surround = "",
          toggle_comment_debug_prints = "",
          delete_debug_prints = "gpx",
        },
        insert = { plain = "", variable = "" },
        visual = { variable_below = "gpj", variable_above = "gpk" },
      },
    },
    keys = {
      { "gpJ", desc = "Debugprint: Plain below" },
      { "gpK", desc = "Debugprint: Plain above" },
      { "gps", desc = "Debugprint: Surround Variable" },
      { "gpS", desc = "Debugprint: Surround plain" },
      { "gpo", desc = "Debugprint: Textobj below" },
      { "gpO", desc = "Debugprint: Textobj above" },
      { "gpx", desc = "Debugprint: Delete all debug prints" },
      { "gpj", mode = { "n", "v" }, desc = "Debugprint: Variable below" },
      { "gpk", mode = { "n", "v" }, desc = "Debugprint: Variable above" },
      { "gpf", ":Debugprint search<Cr>", desc = "Debugprint: Search" },
      { "gp/", ":Debugprint commenttoggle<Cr>", desc = "Debugprin: Toggle comment" },
      { "gpt", ":Debugprint search<Cr>", desc = "Debugprint: search in telescope" },
      { "gpq", ":Debugprint qflist<Cr>", desc = "Debugprint: Add debugs to quickfix list" },
    },
    cmd = { "Debugprint" },
  },

  {
    "Weissle/persistent-breakpoints.nvim",
    config = function()
      require("persistent-breakpoints").setup()
      require("persistent-breakpoints.api").load_breakpoints()
    end,
    keys = wrap_keys {
      { "<leader>db", ":PBToggleBreakpoint<CR>", desc = "Debuger Toggle BreakPoint" },
      {
        "<leader>dC",
        ":PBSetConditionalBreakpoint<CR>",
        desc = "Debuger Toggle Conditional BreakPoint",
      },
      { "<leader>dl", ":PBSetLogPoint<CR>", desc = "Debuger Toggle Log BreakPoint" },
      { "<leader>dB", ":PBClearAllBreakpoints<CR>", desc = "Debuger Clear All BreakPoint" },
    },
  }, -- BreakPoint data is not lost

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      { "mfussenegger/nvim-dap-python", lazy = true },
    },
    keys = wrap_keys {
      { "<leader>dc", ":lua require('dap').continue() <CR>", desc = "Debugger Continue" },
    },

    config = function()
      local dap, dapui = require "dap", require "dapui"
      local virtual_text = require "nvim-dap-virtual-text"
      local mason = vim.fn.stdpath "data" .. "/mason/packages"
      require("dap-python").setup(mason .. "/debugpy/venv/bin/python")
      virtual_text.setup {}

      dapui.setup {
        icons = { collapsed = "", current_frame = "", expanded = "" },
        layouts = {
          {
            elements = {
              { id = "repl", size = 0.1 },
              { id = "console", size = 0.3 },
              { id = "scopes", size = 0.45 },
              { id = "stacks", size = 0.15 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "breakpoints", size = 0.5 },
              { id = "watches", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      }

      dap.adapters["pwa-node"] = { --- yay -Sy --noconfirm --needed vscode-js-debug-bin
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-dap",
          args = { "${port}" },
        },
      }

      local ts_config = {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      }

      dap.configurations.typescript = { ts_config }
      dap.configurations.javascript = { ts_config }
      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close

      map("<leader>de", dapui.eval, "Debugger Eval")
      map("<leader>di", dap.step_into, "Debugger Step Into")
      map("<leader>dO", dap.step_out, "Debugger Step Out")
      map("<leader>do", dap.step_over, "Debugger Step Over")
      map("<leader>dp", dap.pause, "Debugger Pause")
      map("<leader>dr", dap.restart_frame, "Debugger Restart")
      map("<leader>dR", dap.run_to_cursor, "Debugger Run to Cursor")
      map("<leader>ds", ":DapTerminate<CR>", "Debugger Stop")
      map("<leader>dT", dapui.toggle, "Debugger UI Toggle")
      map("<leader>dt", virtual_text.toggle, "Debugger Toggle Virtual Text")
    end,
  },
}
