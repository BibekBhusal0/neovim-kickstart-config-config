local pm = {}
local plugins = {}

--[[
Plugin spec:
  [1]: string           src — "user/repo" or full https URL
  name?: string         auto-derived from src if omitted
  config?: function
  opts?: table          passed to require(name).setup()
  build?: string|function
  dependencies?: string[]
  keys?: { [1]=lhs, [2]=rhs?, mode?, desc? }[]
  cmd?: string[]
  event?: string[]
  ft?: string[]
  enabled?: boolean
  lazy?: boolean
  version?: string

Internal:
  is_loaded: boolean
  is_loading: boolean
]]

local function resolve_name(src)
  if not src then
    return nil
  end
  local name = src:match "[^/]+$" or src
  return name:gsub("%.nvim$", "")
end

local function normalize_src(src)
  return src:find("https://", 1, true) == 1 and src or ("https://github.com/" .. src)
end

local function execute(command)
  if type(command) == "function" then
    command()
  else
    vim.cmd(command)
  end
end

local function build(pkg)
  if not pkg.build then
    return
  end
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if name == pkg.name and (kind == "update" or kind == "install") then
        if not ev.data.active then
          vim.cmd.packadd(pkg.name)
        end
        execute(pkg.build)
      end
    end,
  })
end

local function command_stub(command, name)
  vim.api.nvim_create_user_command(command, function()
    vim.api.nvim_del_user_command(command)
    pm.load_plugin(name)
    vim.cmd(command)
  end, { desc = "Lazy-load trigger for: " .. command })
end

local function load_on_command(cmd, pkg)
  for _, _cmd in ipairs(cmd) do
    command_stub(_cmd, pkg.name)
  end
end

local function load_on_event(events, pkg)
  vim.api.nvim_create_autocmd(events, {
    once = true,
    callback = function()
      pm.load_plugin(pkg.name)
    end,
  })
end

local function load_on_key(keys, pkg)
  for _, map in ipairs(keys) do
    local lhs, rhs = map[1], map[2]
    local mode = map.mode or "n"

    vim.keymap.set(mode, lhs, function()
      pm.load_plugin(pkg.name)

      if rhs then
        execute(rhs)
      else
        -- remove stub so plugin's own keymap takes over, then replay
        vim.keymap.del(mode, lhs)
        local feed = vim.api.nvim_replace_termcodes(lhs, true, false, true)
        vim.api.nvim_feedkeys(feed, mode, false)
      end
    end, { desc = map.desc })
  end
end

local function load_on_filetype(fts, pkg)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = fts,
    once = true,
    callback = function()
      pm.load_plugin(pkg.name)
    end,
  })
end

function pm.load_plugin(name)
  print "loading ..."
  local plugin = plugins[name]
  if not plugin then
    return
  end

  if plugin.enabled == false or plugin.is_loaded or plugin.is_loading then
    return
  end

  plugin.is_loading = true

  if plugin.dependencies then
    for _, dep in ipairs(plugin.dependencies) do
      pm.load_plugin(dep)
    end
  end

  local src = normalize_src(plugin.src)
  print(src)
  vim.pack.add { {
    src = src,
    name = plugin.name,
    version = plugin.version,
  } }
  print "pack add done"
  if type(plugin.config) == "function" then
    plugin.config()
  elseif plugin.opts then
    require(plugin.name).setup(plugin.opts)
  end

  plugin.is_loading = false
  plugin.is_loaded = true
end

function pm.add_plugin(plugin, lazy)
  print(vim.inspect(plugin))
  vim.validate {
    plugin = { plugin, "table" },
    src = { plugin[1], "string" },
  }

  plugin.src = plugin[1]
  plugin.name = plugin.name or resolve_name(plugin.src)

  if plugins[plugin.name] then
    return
  end

  plugin.is_loaded = false
  plugin.is_loading = false
  plugins[plugin.name] = plugin

  if plugin.enabled == false then
    return
  end

  build(plugin)

  if plugin.dependencies then
    for _, dep in ipairs(plugin.dependencies) do
      pm.add_plugin(dep, true)
    end
  end

  if plugin.cmd then
    load_on_command(plugin.cmd, plugin)
  end
  if plugin.event then
    load_on_event(plugin.event, plugin)
  end
  if plugin.keys then
    load_on_key(plugin.keys, plugin)
  end
  if plugin.ft then
    load_on_filetype(plugin.ft, plugin)
  end

  local is_lazy = lazy or plugin.lazy or plugin.cmd or plugin.event or plugin.keys or plugin.ft
  if not is_lazy then
    print("is lazy", is_lazy)
    pm.load_plugin(plugin.name)
  end
end

--- @param list table[]
function pm.add_plugins(list)
  vim.validate { list = { list, "table" } }
  for _, plugin in ipairs(list) do
    pm.add_plugin(plugin)
  end
end

return pm
