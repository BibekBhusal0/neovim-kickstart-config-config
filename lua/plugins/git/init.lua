local map = require "utils.map"
local icons = require "utils.icons"

local function parse(text)
  local handle = io.popen("devmoji --text " .. vim.fn.shellescape(text))
  if handle then
    local emojified_text = handle:read "*a"
    handle:close()
    emojified_text = emojified_text:match "^%s*(.-)%s*$"
    return emojified_text
  else
    return text
  end
end

local function get_title_from_message(message)
  local title = message:match "^([^\n]*)"
  return title or ""
end

local function commit_with_message()
  require "utils.commit_input"(" Commit Changes ", function(text)
    local commit_message = parse(text)
    local result = vim.system({ "git", "commit", "-m", commit_message }):wait()
    if result.code == 0 then
      local title = get_title_from_message(commit_message)
      vim.notify(string.format("%s Committed: %s", icons.others.github, title), vim.log.levels.INFO)
    else
      local error_msg = result.stderr:match "[^\r\n]+"
      if error_msg and error_msg ~= "" then
        vim.notify(string.format("Commit failed: %s", error_msg), vim.log.levels.ERROR)
      else
        vim.notify(string.format "Commit failed", vim.log.levels.ERROR)
      end
    end
  end)
end

local function commit_all_with_message()
  local add_result = vim.system({ "git", "add", "." }):wait()
  if add_result.code ~= 0 then
    local error_msg = add_result.stderr:match "[^\r\n]+"
    if error_msg then
      vim.notify(string.format("Failed to add: %s", error_msg), vim.log.levels.ERROR)
    else
      vim.notify(string.format "Failed to add", vim.log.levels.ERROR)
    end
    return
  end

  require "utils.commit_input"(" Add and Commit ", function(text)
    local commit_message = parse(text)
    local result = vim.system({ "git", "commit", "-m", commit_message }):wait()
    if result.code == 0 then
      local title = get_title_from_message(text)
      vim.notify(string.format("%s Committed: %s", icons.others.github, title), vim.log.levels.INFO)
    else
      local error_msg = result.stderr:match "[^\r\n]+"
      if error_msg then
        vim.notify(string.format("Commit failed: %s", error_msg), vim.log.levels.ERROR)
      else
        vim.notify(string.format "Commit failed", vim.log.levels.ERROR)
      end
    end
  end)
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
  require "utils.commit_input"(" Change Commit Message ", function(text)
    local commit_message = parse(text)
    local result = vim.system({ "git", "commit", "--amend", "-m", commit_message }):wait()
    if result.code == 0 then
      local title = get_title_from_message(text)
      vim.notify(string.format("%s Amended: %s", icons.others.github, title), vim.log.levels.INFO)
    else
      local error_msg = result.stderr:match "[^\r\n]+"
      if error_msg then
        vim.notify(string.format("Amend failed: %s", error_msg), vim.log.levels.ERROR)
      else
        vim.notify(string.format "Amend failed", vim.log.levels.ERROR)
      end
    end
  end, m)
end

local function open_changed_files_in_buffers()
  -- Get the list of changed and untracked files from git
  local handle = io.popen "git ls-files --modified --others --exclude-standard"
  if not handle then
    return
  end
  local result = handle:read "*a"
  handle:close()

  local count = 0
  for file in result:gmatch "[^\r\n]+" do
    -- Check if file exists (prevents errors on deleted files)
    if vim.fn.filereadable(file) == 1 then
      vim.cmd("badd " .. vim.fn.fnameescape(file))
      count = count + 1
    end
  end

  if count > 0 then
    print("Opened " .. count .. " changed files into buffers.")
    local first_file = result:match "[^\r\n]+"
    vim.cmd("edit " .. vim.fn.fnameescape(first_file))
  else
    print "No changed files to open."
  end
end

vim.api.nvim_create_user_command("GitChanges", open_changed_files_in_buffers, {})
map("<leader>gc", commit_all_with_message, "Git commit all")
map("<leader>gC", commit_with_message, "Git commit")
map("<leader>ge", change_last_commit_message, "Git change last commit message")
map("<leader>gg", ":GitChanges<CR>", "Git open changes")

return {
  require "plugins.git.diffview",
  require "plugins.git.fugitive",
  require "plugins.git.gitsigns",
  require "plugins.git.pipeline",
  require "plugins.git.octo",
  require "plugins.git.worktree",
}
