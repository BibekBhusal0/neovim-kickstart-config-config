local colors = {
  active_fg = "#1e1e2e",
  active_bg = "#cba6f7",
  inactive_fg = "#cdd6f4",
  inactive_bg = "#45475a",
  orange = "#ff9e64",
  green = "#74dfa2",
  red = "#f31260",
}

local function hl(name, val)
  if val.bg == nil then
    val.bg = "NONE"
  end
  vim.api.nvim_set_hl(0, name, val)
end
local function setup_highlights()
  -- Common UI Highlights
  hl("UIActive", { fg = colors.active_fg, bg = colors.active_bg, bold = true })
  hl("UIActiveSep", { fg = colors.active_bg })
  hl("UIInactive", { fg = colors.inactive_fg, bg = colors.inactive_bg })
  hl("UIInactiveSep", { fg = colors.inactive_bg })

  hl("UIRed", { fg = colors.red, bg = "NONE" })
  hl("UIOrange", { fg = colors.orange, bg = "NONE" })
  hl("TabLineFill", { bg = "NONE" })
  hl("TabLine", { bg = "NONE" })
end

setup_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_highlights,
})

return {}
