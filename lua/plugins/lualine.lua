return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    {
      enabled = true,
      "vimpostor/vim-tpipeline",
      config = function()
        vim.g.tpipeline_autoembed = 1
        vim.g.tpipeline_restore = 0
        vim.g.tpipeline_clearstl = 1
        vim.g.tpipeline_focuslost = 0
      end,
    },
  },
  event = "VimEnter",
  config = function()
    local mode = {
      "mode",
      fmt = function(str)
        return " " .. str
        -- .. str:sub(1, 1) -- displays only the first character of the mode
      end,
      separator = { left = "" },
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

    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

    local colors = {
      color3 = "#303030",
      color6 = "#9e9e9e",
      color7 = "#80a0ff",
      color8 = "#ae81ff",
      color0 = "#1c1c1c",
      color1 = "#ff5189",
      color2 = "#c6c6c6",
    }

    local moonfly_transparent = {
      replace = {
        a = { fg = colors.color0, bg = colors.color1, gui = "bold" },
        b = { fg = colors.color2, bg = colors.color3 },
      },
      inactive = {
        a = { fg = colors.color6, bg = colors.color3, gui = "bold" },
        b = { fg = colors.color6, bg = colors.color3 },
        c = { fg = colors.color6, bg = "NONE" },
      },
      normal = {
        a = { fg = colors.color0, bg = colors.color7, gui = "bold" },
        b = { fg = colors.color2, bg = colors.color3 },
        c = { fg = colors.color2, bg = "NONE" },
      },
      visual = {
        a = { fg = colors.color0, bg = colors.color8, gui = "bold" },
        b = { fg = colors.color2, bg = colors.color3 },
      },
      insert = {
        a = { fg = colors.color0, bg = colors.color2, gui = "bold" },
        b = { fg = colors.color2, bg = colors.color3 },
      },
    }

    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = moonfly_transparent,
        --          
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },

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
        },
        lualine_y = { codeium_status, plugins },
        lualine_z = { { getFileName, separator = { right = "" } } },
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

    if os.getenv "TMUX" ~= nil then
      vim.o.laststatus = 0
    end
  end,
}
