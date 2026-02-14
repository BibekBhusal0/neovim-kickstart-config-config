local utils = require "utils.screenshot"

return {
  {
    "mistweaverco/snap.nvim",
    cmd = "Snap",
    opts = {
      templateFilepath = vim.fn.stdpath "config" .. "/snap/template.html",
      save_to_disk = { image = true },
      output_dir = "~/Code/Screenshots/",
      filename_pattern = "%file_name.%file_extension-%t",
      additional_template_data = utils.defaultTemplate,
    },
  },
}
