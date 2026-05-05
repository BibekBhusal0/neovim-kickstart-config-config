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
  vim.cmd.packadd(name)

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
  -- print(vim.inspect(plugin))
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
      if type(plugin.dependencies == "string") then
        pm.add_plugin({ dep }, true)
      else
        pm.add_plugin(dep, true)
      end
    end
  end

  local src = normalize_src(plugin.src)
  vim.pack.add({ {
    src = src,
    name = plugin.name,
    version = plugin.version,
  } }, {
    load = function()
      local is_lazy = lazy
      if is_lazy == nil then
        is_lazy = plugin.lazy
      end
      if is_lazy == nil then
        is_lazy = plugin.cmd or plugin.event or plugin.keys or plugin.ft
      end
      if not is_lazy then
        print("is lazy", is_lazy)
        pm.load_plugin(plugin.name)
        return
      end

      if plugin.event then
        vim.api.nvim_create_autocmd(plugin.event, {
          once = true,
          callback = function()
            pm.load_plugin(plugin.name)
          end,
        })
      end
    end,
  })
end

--- @param list table[]
function pm.add_plugins(list)
  vim.validate { list = { list, "table" } }
  for _, plugin in ipairs(list) do
    if type(plugin) == "string" then
      pm.add_plugin { plugin }
    elseif type(plugin) == "table" then
      if type(plugin[1]) == "string" then
        pm.add_plugin(plugin)
      elseif type(plugin[1] == "table") then
        pm.add_plugins(plugin)
      end
    end
  end
end

return pm
