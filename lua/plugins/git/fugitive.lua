local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

map("<leader>g/", ":Git stash<CR>", "Git stash")
map("<leader>g[", ":Git push --force<CR>", "Git push Force")
map("<leader>gA", ":Git add %<CR>", "Git add current file")
map("<leader>ga", ":Git add .<CR>", "Git add all files")
map("<leader>gi", ":Git init<CR>", "Git Init")
map("<leader>gJ", ":Git commit --amend --no-edit<CR>", "Git commit to last commit")
map("<leader>gj", ":Git commit -a --amend --no-edit<CR>", "Git add and commit to last commit")
map("<leader>gP", ":Git pull<CR>", "Git pull")
map("<leader>gp", ":Git push<CR>", "Git push")

local function newBranch()
  require "utils.input"("Branch Name", function(text)
    local safe = vim.fn.shellescape(vim.trim(text))
    vim.cmd("Git checkout -b " .. safe)
  end, "", 20, require("utils.icons").others.git .. " ")
end

map("<leader>Gb", newBranch, "Git New Branch")

return {
  {
    "tpope/vim-fugitive",
    cmd = {
      "GBrowse",
      "GDelete",
      "Gdiffsplit",
      "Gedit",
      "Ggrep",
      "Git",
      "GMove",
      "Gread",
      "GRemove",
      "GRename",
      "Gwrite",
    },
  },

  {
    "tpope/vim-rhubarb",
    cmd = { "GBrowse" },
    keys = wrap_keys {
      { "<leader>go", ":GBrowse<CR>", desc = "Git open in browser", mode = { "n", "v" } },
    },
  },
}
