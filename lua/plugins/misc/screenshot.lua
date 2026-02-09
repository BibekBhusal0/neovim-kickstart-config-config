local wrap_keys = require "utils.wrap_keys"
local screenshotFolder = "~/Code/Screenshots/"

---Take Screenshot after setting up snap's config
---@param config SnapUserConfig to overwrite
local function snap(config)
  require("snap.config").set(config)
  local mode = vim.api.nvim_get_mode().mode
  if mode:match "^v" or mode:match "^V" then
    vim.cmd "'<,'>Snap"
    return
  end
  vim.cmd "Snap"
end

local function snap_to_desktop()
  snap {
    save_to_disk = { image = true },
    copy_to_clipboard = { image = false },
  }
end

local function snap_to_clipboard()
  snap {
    save_to_disk = { image = false },
    copy_to_clipboard = { image = true },
  }
end

return {
  {
    "mistweaverco/snap.nvim",
    cmd = "Snap",
    keys = wrap_keys {
      { "<leader>sc", snap_to_clipboard, desc = "Screenshot to clipboard", mode = { "n", "v" } },
      { "<leader>sC", snap_to_desktop, desc = "Screenshot to desktop", mode = { "n", "v" } },
    },
    opts = {
      output_dir = screenshotFolder,
      filename_pattern = "%file_name.%file_extension-%t",
    },
  },
}
