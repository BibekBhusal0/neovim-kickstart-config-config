local original_select = vim.ui.select
vim.ui.select = function(...)
  local ok, telescope = pcall(require, "telescope")
  if ok then
    telescope.setup {
      extensions = { ["ui-select"] = require("telescope.themes").get_dropdown() },
    }
    pcall(telescope.load_extension, "ui-select")
    if vim.ui.select ~= original_select then
      return vim.ui.select(...)
    end
  end
  return original_select(...)
end

return {
  "nvim-telescope/telescope-ui-select.nvim",
  lazy = true,
}
