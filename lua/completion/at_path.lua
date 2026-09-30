local M = {}

function M.new()
  return setmetatable({}, { __index = M })
end

function M:is_available()
  return true
end

function M:get_debug_name()
  return "at_path"
end

function M:get_trigger_characters()
  return { "@", "/", ".", "-", "_" }
end

function M:get_keyword_pattern()
  return [[@[^@\s]*]]
end

local function get_buf_dir()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname ~= "" then
    local dir = vim.fn.fnamemodify(bufname, ":p:h")
    if vim.fn.isdirectory(dir) == 1 then
      return dir
    end
  end
  return nil
end

local function get_base_dir(query)
  if query:sub(1, 2) == "./" or query:sub(1, 3) == "../" or query == "." or query == ".." then
    return get_buf_dir() or vim.fn.getcwd()
  end
  return vim.fn.getcwd()
end

function M:complete(params, callback)
  local line_before = params.context.cursor_before_line or ""
  local query = line_before:match "@([^@%s]*)$"
  if query == nil then
    callback {}
    return
  end

  local search_dir, label_prefix, prefix
  if query:sub(1, 1) == "/" then
    local dir, pre = query:match "^(.*/)([^/]*)$"
    search_dir = dir or "/"
    label_prefix = dir or "/"
    prefix = pre or ""
  elseif query:sub(1, 2) == "~/" or query == "~" then
    local rest = query:sub(2)
    local dir_rel, pre = rest:match "^(.*/)([^/]*)$"
    if dir_rel then
      search_dir = vim.fn.expand("~" .. dir_rel)
      label_prefix = "~" .. dir_rel
      prefix = pre
    else
      search_dir = vim.fn.expand "~"
      label_prefix = "~/"
      prefix = rest:sub(2)
    end
  else
    local dir_rel, pre = query:match "^(.*/)([^/]*)$"
    local base = get_base_dir(query)
    if dir_rel then
      search_dir = base .. "/" .. dir_rel
      label_prefix = dir_rel
      prefix = pre
    else
      search_dir = get_base_dir(query)
      label_prefix = ""
      prefix = query
    end
  end

  search_dir = vim.fn.resolve(vim.fn.expand(search_dir))
  if vim.fn.isdirectory(search_dir) ~= 1 then
    callback {}
    return
  end

  local entries = vim.fn.readdir(search_dir)
  if not entries or #entries == 0 then
    callback {}
    return
  end

  local show_hidden = prefix:sub(1, 1) == "."
  local lower_prefix = prefix:lower()
  local items = {}

  for _, entry in ipairs(entries) do
    if entry ~= "." and entry ~= ".." then
      local is_hidden = entry:sub(1, 1) == "."
      if (show_hidden or not is_hidden) and entry:lower():sub(1, #prefix) == lower_prefix then
        local full = search_dir .. "/" .. entry
        local is_dir = vim.fn.isdirectory(full) == 1
        local label = "@" .. label_prefix .. entry .. (is_dir and "/" or "")
        table.insert(items, {
          label = label,
          insertText = label,
          filterText = label,
          kind = is_dir and vim.lsp.protocol.CompletionItemKind.Folder
            or vim.lsp.protocol.CompletionItemKind.File,
          data = { path = full, is_dir = is_dir },
        })
        if #items >= 200 then
          break
        end
      end
    end
  end

  table.sort(items, function(a, b)
    local a_dir = a.data.is_dir
    local b_dir = b.data.is_dir
    if a_dir ~= b_dir then
      return a_dir
    end
    return a.label < b.label
  end)

  callback(items)
end

return M
