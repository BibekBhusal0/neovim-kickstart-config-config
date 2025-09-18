local wrap_keys = require "utils.wrap_keys"
local map = require "utils.map"

local function commit_with_message()
  require "utils.input"(" Commit Message ", function(text)
    vim.cmd("Git commit -m '" .. text .. "'")
  end, "", 40, require("utils.icons").others.github .. "  ")
end

local function commit_all_with_message()
  require "utils.input"(" Commit Message ", function(text)
    vim.cmd "Git add ."
    vim.cmd("Git commit -am'" .. text .. "'")
  end, "", 50, require("utils.icons").others.github .. "  ")
end

local function change_last_commit_message()
  local handle = io.popen "git log -1 --pretty=%B"
  if not handle then
    return
  end
  local message = handle:read "*a"
  handle:close()
  local m = message:match "^%s*(.-)%s*$"
  if not m then
    return
  end
  require "utils.input"("Commit Message", function(title)
    local cmd = "Git commit --amend -m '" .. title .. "'"
    vim.cmd(cmd)
  end, m, 60, require("utils.icons").others.github .. "  ")
end

map("<leader>g/", ":Git stash<CR>", "Git stash")
map("<leader>g[", ":Git push --force<CR>", "Git push Force")
map("<leader>gA", ":Git add %<CR>", "Git add current file")
map("<leader>ga", ":Git add .<CR>", "Git add all files")
map("<leader>gc", commit_all_with_message, "Git commit all")
map("<leader>gC", commit_with_message, "Git commit")
map("<leader>ge", change_last_commit_message, "Git change last commit message")
map("<leader>gi", ":Git init<CR>", "Git Init")
map("<leader>gJ", ":Git commit --amend --no-edit<CR>", "Git commit to last commit")
map("<leader>gj", ":Git commit -a --amend --no-edit<CR>", "Git add and commit to last commit")
map("<leader>gP", ":Git pull<CR>", "Git pull")
map("<leader>gp", ":Git push<CR>", "Git push")

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
