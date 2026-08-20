local Vi = require "Navigator.mux.vi"

local Herdr = Vi:new()

function Herdr:new()
  local pane = os.getenv "HERDR_PANE_ID"
  assert(pane, "[Navigator] Herdr is not running!")

  local state = {
    pane = pane,
    direction = { p = "", h = "left", k = "up", l = "right", j = "down" },
  }
  self.__index = self
  return setmetatable(state, self)
end

function Herdr:navigate(direction)
  if direction == "p" then
    return self
  end
  vim.fn.jobstart({
    "herdr",
    "pane",
    "focus",
    "--direction",
    self.direction[direction],
    "--pane",
    self.pane,
  }, { detach = true })
  return self
end

return Herdr
