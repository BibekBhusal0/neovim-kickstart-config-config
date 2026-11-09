local M = {}

function M.new()
  return setmetatable({}, { __index = M })
end

function M:is_available()
  return true
end

function M:get_debug_name()
  return "path"
end

function M.has_path_context(line_before)
  return line_before:match "@[^@%s]*$" ~= nil or line_before:match "[-%w%._~/]*/[^%s]*$" ~= nil
end

function M:get_trigger_characters()
  return { "@", "/", "." }
end

function M:get_keyword_pattern()
  -- `@` paths, or a slash-containing path token without the prefix.
  -- %w and \s are not expanded inside [] in Vim regex, so spell them out.
  return [=[\%(@[^@[:space:]]*\|[-A-Za-z0-9._~/]*/[^[:space:]]*\)]=]
end

local MAX_ITEMS = 20
local CACHE_TTL = 2000
local list_cache = {}

local function get_buf_dir()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname ~= "" then
    local dir = vim.fn.fnamemodify(bufname, ":p:h")
    if vim.fn.isdirectory(dir) == 1 then
      return dir
    end
  end
  return vim.fn.getcwd()
end

-- Lists files and directories below root, relative to root and honoring ignore files.
local function list_entries(root, max_depth)
  local now = vim.uv.now()
  local cache_key = max_depth and (root .. "\0" .. max_depth) or root
  local cached = list_cache[cache_key]
  if cached and now - cached.at < CACHE_TTL then
    return cached.entries
  end

  local cmd
  if vim.fn.executable "fd" == 1 then
    cmd = {
      "fd",
      "--hidden",
      "--exclude",
      ".git",
      "--type",
      "f",
      "--type",
      "d",
      "--type",
      "l",
      "--color",
      "never",
      "--max-results",
      "50000",
    }
    if max_depth then
      vim.list_extend(cmd, { "--max-depth", tostring(max_depth) })
    end
  elseif vim.fn.executable "rg" == 1 then
    cmd = { "rg", "--files", "--hidden", "--glob", "!.git" }
    if max_depth then
      vim.list_extend(cmd, { "--max-depth", tostring(max_depth) })
    end
  else
    return {}
  end

  local ok, result = pcall(function()
    return vim.system(cmd, { cwd = root, text = true }):wait()
  end)
  if not ok or not result or not result.stdout then
    return {}
  end

  local entries = {}
  for _, path in ipairs(vim.split(result.stdout, "\n", { plain = true, trimempty = true })) do
    local is_dir = path:sub(-1) == "/"
    table.insert(entries, { path = path:gsub("/$", ""), is_dir = is_dir })
  end

  list_cache[cache_key] = { at = now, entries = entries }
  return entries
end

-- Finds the deepest existing directory in an absolute path and returns the
-- remaining typed text, e.g. /home/bib/Co/sk -> /home/bibek, "Co/sk".
local function split_existing_dir(path)
  local parts = vim.split(path, "/", { plain = true, trimempty = true })
  for i = #parts, 0, -1 do
    local dir = i == 0 and "/" or "/" .. table.concat(parts, "/", 1, i)
    if vim.fn.isdirectory(dir) == 1 then
      return dir, table.concat(parts, "/", i + 1, #parts)
    end
  end
  return nil
end

local function parse_query(query)
  if query:sub(1, 1) == "/" then
    local dir, fragment = split_existing_dir(query)
    if not dir then
      return nil
    end
    return {
      root = dir,
      label_prefix = dir == "/" and "/" or dir .. "/",
      fragment = fragment,
    }
  end

  if query == "~" or query:sub(1, 2) == "~/" then
    local home = vim.fn.expand "~"
    local dir, fragment = split_existing_dir(home .. query:sub(2))
    if not dir then
      return nil
    end
    local prefix
    if dir == home then
      prefix = "~/"
    elseif dir:sub(1, #home + 1) == home .. "/" then
      prefix = "~/" .. dir:sub(#home + 2) .. "/"
    else
      prefix = dir == "/" and "/" or dir .. "/"
    end
    return { root = dir, label_prefix = prefix, fragment = fragment }
  end

  -- Keep ./ and ../ in the inserted text, but search from the resolved root.
  local explicit = query:sub(1, 2) == "./" or query:sub(1, 3) == "../"
  local base = explicit and get_buf_dir() or vim.fn.getcwd()
  local label_prefix = ""
  local rest = query
  while true do
    if rest:sub(1, 2) == "./" then
      label_prefix = label_prefix .. "./"
      rest = rest:sub(3)
    elseif rest:sub(1, 3) == "../" then
      label_prefix = label_prefix .. "../"
      rest = rest:sub(4)
    else
      break
    end
  end

  local root = base
  if label_prefix ~= "" then
    root = vim.fn.resolve(vim.fn.fnamemodify(base .. "/" .. label_prefix, ":p"))
  end
  if vim.fn.isdirectory(root) ~= 1 then
    return nil
  end

  return { root = root, label_prefix = label_prefix, fragment = rest }
end

local function split_dir_fragment(path)
  local dir, fragment = path:match "^(.*/)([^/]*)$"
  if dir then
    return dir, fragment
  end
  return "", path
end

-- Plain path mode uses the buffer directory, like cmp-path. The typed
-- directory must exist, then the tree below it is fuzzy matched.
local function parse_plain_query(query)
  local base, label_prefix, rest

  if query:sub(1, 2) == "~/" then
    local home = vim.fn.expand "~"
    local dir, fragment = split_dir_fragment(home .. query:sub(2))
    if vim.fn.isdirectory(dir) ~= 1 then
      return nil
    end
    local label_dir = dir == home and "~/" or "~" .. dir:sub(#home + 1)
    return { root = dir, label_prefix = label_dir, fragment = fragment }
  elseif query:sub(1, 1) == "/" then
    local dir, fragment = split_dir_fragment(query)
    if vim.fn.isdirectory(dir) ~= 1 then
      return nil
    end
    return { root = dir, label_prefix = dir, fragment = fragment }
  else
    base = get_buf_dir()
    label_prefix = ""
    rest = query
    while true do
      if rest:sub(1, 2) == "./" then
        label_prefix = label_prefix .. "./"
        rest = rest:sub(3)
      elseif rest:sub(1, 3) == "../" then
        label_prefix = label_prefix .. "../"
        rest = rest:sub(4)
      else
        break
      end
    end
    if label_prefix ~= "" then
      base = vim.fn.resolve(vim.fn.fnamemodify(base .. "/" .. label_prefix, ":p"))
    end
  end

  local dir_rel, fragment = split_dir_fragment(rest)
  local root = vim.fn.resolve(vim.fn.fnamemodify(base .. "/" .. dir_rel, ":p"))
  if vim.fn.isdirectory(root) ~= 1 then
    return nil
  end
  return { root = root, label_prefix = label_prefix .. dir_rel, fragment = fragment }
end

local function get_plain_query(line_before)
  local token = line_before:match "([-%w%._~/]*/[^%s]*)$"
  if not token or token:match "^/+$" then
    return nil
  end
  return token
end

local function shallow_sort(entries)
  table.sort(entries, function(a, b)
    local a_depth = select(2, a.path:gsub("/", ""))
    local b_depth = select(2, b.path:gsub("/", ""))
    if a_depth ~= b_depth then
      return a_depth < b_depth
    end
    return a.path < b.path
  end)
end

function M:complete(params, callback)
  local line_before = params.context.cursor_before_line or ""
  local query = line_before:match "@([^@%s]*)$"
  local plain = false
  if query == nil then
    query = get_plain_query(line_before)
    plain = true
    if not query then
      callback {}
      return
    end
  end

  local parsed
  if plain then
    parsed = parse_plain_query(query)
  else
    parsed = parse_query(query)
  end
  if not parsed then
    callback {}
    return
  end

  local entries = list_entries(parsed.root, parsed.fragment == "" and 1 or nil)
  if #entries == 0 then
    callback {}
    return
  end

  local matched
  if parsed.fragment == "" then
    matched = vim.list_slice(entries)
    shallow_sort(matched)
  else
    matched = vim.fn.matchfuzzy(entries, parsed.fragment, { key = "path" })
  end

  local items = {}
  local source_prefix = plain and "" or "@"
  for _, entry in ipairs(matched) do
    local label = source_prefix .. parsed.label_prefix .. entry.path .. (entry.is_dir and "/" or "")
    table.insert(items, {
      label = label,
      insertText = label,
      filterText = label,
      kind = entry.is_dir and vim.lsp.protocol.CompletionItemKind.Folder
        or vim.lsp.protocol.CompletionItemKind.File,
      data = {
        path = parsed.root == "/" and "/" .. entry.path or parsed.root .. "/" .. entry.path,
        is_dir = entry.is_dir,
        plain = plain,
      },
    })
    if #items >= MAX_ITEMS then
      break
    end
  end

  -- Every keystroke changes the fuzzy query, so tell cmp to ask again instead
  -- of only re-filtering the entries from the first request.
  callback { items = items, isIncomplete = true }
end

return M
