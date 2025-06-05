local map = require "utils.map"

local selected_bg = "#095028"
local bg = "#18181b"
local tab_selected = "#74dfa2"
local tab = "#052814"
local close = "#f31260"
local fg = "#e4e4e7"
local main_bg = { attribute = "bg", highlight = "Normal" }

return {
  "akinsho/bufferline.nvim",
  event = "VimEnter",
  config = function()
    local highlights = {
      background = { bg = bg },
      fill = { bg = main_bg, fg = selected_bg },
      tab_close = { fg = close },
      trunc_marker = { bg = bg, fg = fg },
      tab = { bg = tab, fg = tab_selected },
      tab_selected = { bg = tab_selected, fg = tab },
      tab_separator = { bg = tab, fg = main_bg },
      tab_separator_selected = { bg = tab_selected, fg = main_bg },
    }

    local set_colors = function(
      keys,
      foreground,
      foreground_selected,
      background,
      background_selected
    )
      local suffix = { "_selected", "_visible", "" }
      for _, p in pairs(keys) do
        for _, s in pairs(suffix) do
          local key = p .. s
          local colors = { bg = background or bg, fg = foreground }
          if s == "_selected" then
            colors = {
              bg = background_selected or background or selected_bg,
              fg = foreground_selected or foreground,
            }
          end
          highlights[key] = colors
        end
      end
    end

    set_colors({
      "hint",
      "warning",
      "error",
      "info",
      "hint_diagnostic",
      "warning_diagnostic",
      "error_diagnostic",
      "info_diagnostic",
      "numbers",
      "buffer",
      "diagnostic",
      "modified",
      "duplicate",
    }, fg)
    set_colors({ "close_button", "pick" }, close)
    set_colors({ "separator" }, main_bg)
    -- set_colors({ 'separator' }, bg, selected_bg, main_bg, main_bg)

    local bufferline = require "bufferline"
    bufferline.setup {
      options = {
        mode = "buffers",
        groups = {
          items = {
            require("bufferline.groups").builtin.pinned:with { icon = "󰐃 " },
          },
        },

        themable = false,
        close_command = "Bdelete! %d",
        close_icon = " 󰅙",
        middle_mouse_command = "Bdelete! %d",
        max_name_length = 30,
        max_prefix_length = 30,
        truncate_names = true,
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count)
          return "(" .. count .. ")"
        end,
        offsets = {
          {
            filetype = "codecompanion",
            text = "Code Companion",
            text_aligh = "center",
            separator = true,
          },
          { filetype = "Avante" },
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true,
        separator_style = "slope",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        show_tab_indicators = true,
        indicator = { style = "icon", icon = "" },
        minimum_padding = 1,
        maximum_padding = 3,
        maximum_length = 15,
        sort_by = "insert_at_end",
        hover = { enabled = true, delay = 200, reveal = { "close" } },
      },
      highlights = highlights,
    }

    local function renameTab()
      require "utils.input"("Tab name", function(text)
        bufferline.rename_tab { text }
      end, "", 15, "󰓩 ")
    end
    map("<leader>bc", ":BufferLinePick<CR>", "Buffer Pick")
    map("<leader>bC", bufferline.close_with_pick, "Buffer Pick and close")
    map("<leader>bH", ":BufferLineCloseLeft<CR>", "Buffer Close Prev")
    map("<leader>bj", ":BufferLineMovePrev<CR>", "Buffer Move Prev")
    map("<leader>bk", ":BufferLineMoveNext<CR>", "Buffer Move Next")
    map("<leader>bL", ":BufferLineCloseRight<CR>", "Buffer Close Next")
    map("<leader>bo", ":BufferLineCloseOthers<CR>", "Buffer Close others")
    map("<leader>bp", ":BufferLineTogglePin<CR>", "Buffer Toggle Pin")
    map("<leader>bse", ":BufferLineSortByExtension<CR>", "Buffer Sort By Extension")
    map("<leader>bsr", ":BufferLineSortByRelativeDirectory<CR>", "Buffer Sort By Directory")
    map("<leader>tr", renameTab, "Remane tab")
    map("<S-Tab>", ":BufferLineCyclePrev<CR>", "Buffer Cycle Previous")
    map("<Tab>", ":BufferLineCycleNext<CR>", "Buffer Cycle Next")
  end,
}
