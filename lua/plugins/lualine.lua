return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    {
      enabled = false,
      "vimpostor/vim-tpipeline",
      config = function()
        vim.g.tpipeline_autoembed = 1
        vim.g.tpipeline_restore = 1
        vim.g.tpipeline_clearstl = 1
      end,
    },
  },
  event = "VimEnter",
  config = function()
    local mode = {
      "mode",
      fmt = function(str)
        return " " .. str
      end,
      -- .. str:sub(1, 1) -- displays only the first character of the mode
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local getFileName = function()
      if hide_in_width() then
        return vim.fn.fnamemodify(vim.fn.expand "%:p", ":.")
      else
        return vim.fn.expand "%:t"
      end
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = require("utils.icons").get_padded_icon "diagnostics",
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      "diff",
      symbols = require("utils.icons").get_padded_icon "git",
      cond = hide_in_width,
    }

    local codeium_status = {
      function()
        if not package.loaded["neocodeium"] then
          return " "
        end
        local symbols = {
          status = {
            [0] = "󰚩 ", -- Enabled
            [1] = "󱚧 ", -- Disabled Globally
            [2] = "󱙻 ", -- Disabled for Buffer
            [3] = "󱙺 ", -- Disabled for Buffer fileType
            [4] = "󱙺 ", -- Disabled for Buffer with enabled function
            [5] = "󱚠 ", -- Disabled for Buffer encoding
          },
          server_status = {
            [0] = "󰣺 ", -- Connected
            [1] = "󰣻 ", -- Connecting
            [2] = "󰣽 ", -- Disconnected
          },
        }
        local status, serverStatus = require("neocodeium").get_status()
        return symbols.status[status] .. symbols.server_status[serverStatus]
      end,
      cond = hide_in_width,
    }

    local noice_info = {
      function()
        if not package.loaded["noice"] then
          return ""
        end
        local cmd = require("noice").api.status.command.get() or ""
        local get = require("noice").api.status.mode.get() or ""
        return get .. "  " .. cmd
      end,
    }

    local plugins = {
      function()
        local stats = require("lazy").stats()
        return (string.format(" %d/%d", stats.loaded, stats.count))
      end,
    }
    -- local pomodoro = {
    --   function()
    --     if not package.loaded["pomodoro"] then
    --       return " 0:0"
    --     end
    --     return require("pomodoro").get_pomodoro_status("", "", "")
    --   end,
    --   cond = hide_in_width,
    -- }

    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = "onedark",
        --          
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },

        disabled_filetypes = {
          "alpha",
          "codecompanion",
          "Avante",
          "AvanteInput",
          "neo-tree",
          "noice",
          "qf",
          "quickrun",
          "terminal",
          "trouble",
        },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { "branch" },
        lualine_c = { diff },
        lualine_x = {
          noice_info,
          diagnostics,
          { "filetype", cond = hide_in_width },
          {
            -- https://ravitemer.github.io/mcphub.nvim/extensions/lualine.html
            function()
              -- Check if MCPHub is loaded
              if not vim.g.loaded_mcphub then
                return "󰐻 -"
              end

              local count = vim.g.mcphub_servers_count or 0
              local status = vim.g.mcphub_status or "stopped"
              local executing = vim.g.mcphub_executing

              -- Show "-" when stopped
              if status == "stopped" then
                return "󰐻 -"
              end

              -- Show spinner when executing, starting, or restarting
              if executing or status == "starting" or status == "restarting" then
                local frames =
                  { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                return "󰐻 " .. frames[frame]
              end

              return "󰐻 " .. count
            end,
            color = function()
              if not vim.g.loaded_mcphub then
                return { fg = "#6c7086" } -- Gray for not loaded
              end

              local status = vim.g.mcphub_status or "stopped"
              if status == "ready" or status == "restarted" then
                return { fg = "#50fa7b" } -- Green for connected
              elseif status == "starting" or status == "restarting" then
                return { fg = "#ffb86c" } -- Orange for connecting
              else
                return { fg = "#ff5555" } -- Red for error/stopped
              end
            end,
          },
        },
        lualine_y = { codeium_status, plugins },
        lualine_z = { getFileName },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { { "location", padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "fugitive" },
    }
  end,
}
