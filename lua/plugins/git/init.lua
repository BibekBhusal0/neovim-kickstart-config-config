local map = require "utils.map"
local function open_changed_files_in_buffers()
  -- Get the list of changed and untracked files from git
  local handle = io.popen("git ls-files --modified --others --exclude-standard")
  if not handle then return end
  local result = handle:read("*a")
  handle:close()

  local count = 0
  for file in result:gmatch("[^\r\n]+") do
    -- Check if file exists (prevents errors on deleted files)
    if vim.fn.filereadable(file) == 1 then
      vim.cmd("badd " .. vim.fn.fnameescape(file))
      count = count + 1
    end
  end

  if count > 0 then
    print("Opened " .. count .. " changed files into buffers.")
    local first_file = result:match("[^\r\n]+")
    vim.cmd("edit " .. vim.fn.fnameescape(first_file))
  else
    print("No changed files to open.")
  end
end

vim.api.nvim_create_user_command("GitChanges", open_changed_files_in_buffers, {})
map("<leader>gg", ":GitChanges<CR>", "Git open changes")

return {
  require "plugins.git.diffview",
  require "plugins.git.fugitive",
  require "plugins.git.gitsigns",
  require "plugins.git.pipeline",
  require "plugins.git.octo",
  require "plugins.git.lazygit",
  require "plugins.git.tardis",
  require "plugins.git.worktree",
}
