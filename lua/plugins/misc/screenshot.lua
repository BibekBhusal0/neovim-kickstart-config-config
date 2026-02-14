local map = require "utils.map"
local utils = require "utils.screenshot"
local screenshot_dir = "~/Code/Screenshots/"
map("<leader>Sc", ":silent !nautilus " .. screenshot_dir .. "&<CR>", "Open Screenshot directory")

return {
  {
    "mistweaverco/snap.nvim",
    cmd = "Snap",
    opts = {
      templateFilepath = vim.fn.stdpath "config" .. "/snap/template.html",
      save_to_disk = { image = true },
      output_dir = screenshot_dir,
      filename_pattern = "%file_name.%file_extension-%t",
      additional_template_data = utils.defaultTemplate,
    },
  },
}
