local M = {}
M.bg_transparent = true

M.apply_transparency = function(color)
  local bg = "none"
  if not M.bg_transparent then
    bg = color or "#080808"
  end

  local allHighlights = {
    "Normal",
    "NormalFloat",
    "Error",
    "ErrorMsg",
    "WarinigMsg",
    "LineNr",
    "SignColumn",
    "SpecialKey",
    "FloatBorder",
    "NvimTreeNormalFloat",
    "MatchWordCur",
    "FoldColumn",
    "TelescopeBorder",
    "TelescopePromptBorder",
    "TelescopeResultsBorder",
    "TelescopePreviewBorder",
    "NotifyERRORBorder",
    "NotifyWARNBorder",
    "NotifyINFOBorder",
    "NotifyDEBUGBorder",
    "NotifyTRACEBorder",
    "NotifyERRORIcon",
    "NotifyWARNIcon",
    "NotifyINFOIcon",
    "NotifyDEBUGIcon",
    "NotifyTRACEIcon",
    "NotifyERRORTitle",
    "NotifyWARNTitle",
    "NotifyINFOTitle",
    "NotifyDEBUGTitle",
    "NotifyTRACETitle",
    "NotifyBackground",
  }
  for _, hl in pairs(allHighlights) do
    vim.api.nvim_set_hl(0, hl, { bg = bg })
  end
end

M.Toggle_transparent = function()
  M.bg_transparent = not M.bg_transparent
  M.apply_transparency()
end

M.enable_transparency = function()
  M.bg_transparent = true
  M.apply_transparency()
end

M.disable_transparency = function(color)
  M.bg_transparent = false
  M.apply_transparency(color)
end

require "utils.map"("<leader>bg", M.Toggle_transparent, "Toggle transparency")

return M
