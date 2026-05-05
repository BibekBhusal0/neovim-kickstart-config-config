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

local function load_on_key(keys, pkg)
  for _, map in ipairs(keys) do
    local lhs, rhs = map[1], map[2]
    local mode = map.mode or "n"

    if not rhs then
      -- :TODO: Loading plugin right away for now
      -- it should load plugin and only on keymap
      pm.load_plugin(pkg.name)
    else
      vim.keymap.set(mode, lhs, function()
        pm.load_plugin(pkg.name)
        if type(rhs) == "function" then
          rhs()
        elseif type(rhs) == "string" then
          local cmd = rhs:match "^:(.+)<[Cc][Rr]>$"
          if cmd then
            vim.cmd(cmd)
          else
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes(rhs, true, false, true),
              "t",
              false
            )
          end
        end
      end, { desc = map.desc })
    end
  end
end

local function load_on_command(commands, plugin)
  if type(commands) == "string" then
    commands = { commands }
  end
  for _, cmd in ipairs(commands) do
    vim.api.nvim_create_user_command(cmd, function(event)
      local command = {
        cmd = cmd,
        bang = event.bang or nil,
        mods = event.smods,
        args = event.fargs,
        count = event.count >= 0 and event.range == 0 and event.count or nil,
      }

      if event.range == 1 then
        command.range = { event.line1 }
      elseif event.range == 2 then
        command.range = { event.line1, event.line2 }
      end

      pm.load_plugin(plugin.name)

      local info = vim.api.nvim_get_commands({})[cmd] or vim.api.nvim_buf_get_commands(0, {})[cmd]
      if not info then
        vim.schedule(function()
          vim.print("Command " .. cmd .. " not found after loading " .. plugin.name)
        end)

        return
      end

      command.nargs = info.nargs

      if event.args and event.args ~= "" and info.nargs and info.nargs:find "[1?]" then
        command.args = { event.args }
      end

      vim.cmd(command)
    end, {
      bang = true,
      range = true,
      nargs = "*",
      complete = function(_, line)
        vim.api.nvim_del_user_command(cmd)
        -- NOTE: return the newly loaded command completion
        return vim.fn.getcompletion(line, "cmdline")
      end,
    })
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
  name = resolve_name(name) or name
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
      pm.load_plugin(type(dep) == "table" and (dep.name or dep[1]) or dep)
    end
  end

  if plugin._install_dir then
    vim.opt.runtimepath:append(plugin._install_dir)
    for _, f in ipairs(vim.fn.glob(plugin._install_dir .. "/plugin/**/*.{vim,lua}", false, true)) do
      vim.cmd("source " .. vim.fn.fnameescape(f))
    end
  else
    vim.cmd.packadd(name)
  end

  if type(plugin.config) == "function" then
    plugin.config()
  elseif plugin.opts then
    require(plugin.main  or plugin.name).setup(plugin.opts)
  end

  plugin.is_loading = false
  plugin.is_loaded = true
end

function pm.add_plugin(plugin, lazy)
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
      if type(dep) == "string" then
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
    load = function(p)
      local is_lazy = lazy
      if is_lazy == nil then
        is_lazy = plugin.lazy
      end
      if is_lazy == nil then
        is_lazy = plugin.cmd or plugin.event or plugin.keys or plugin.ft
      end

      if not is_lazy then
        pm.load_plugin(plugin.name)
        return
      end

      if (p.path) then 
        plugin._install_dir = p.path
        -- vim.opt.runtimepath:append(plugin._install_dir)
      end

      -- for _, pp in ipairs(vim.opt.packpath:get()) do
      --   local dirs = vim.fn.glob(pp .. "/pack/*/opt/" .. plugin.name, false, true)
      --   if #dirs > 0 then
      --     plugin._install_dir = dirs[1]
      --     break
      --   end
      -- end

      if plugin.event then
        local event = plugin.event
        if event == "VeryLazy" or (type(event) == "table" and vim.tbl_contains(event, "VeryLazy")) then
          vim.defer_fn(function()
            pm.load_plugin(plugin.name)
          end, 100)
          return
        end
        vim.api.nvim_create_autocmd(event, {
          once = true,
          callback = function()
            pm.load_plugin(plugin.name)
          end,
        })
      end

      if plugin.ft then
        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = plugin.ft,
          once = true,
          callback = function()
            pm.load_plugin(plugin.name)
          end,
        })
      end

      if plugin.keys then
        load_on_key(plugin.keys, plugin)
      end

      if plugin.cmd then
        load_on_command(plugin.cmd, plugin)
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
      elseif type(plugin[1]) == "table" then
        pm.add_plugins(plugin)
      end
    end
  end
end

function pm.stats()
  local total, loaded = 0, 0
  for _, p in pairs(plugins) do
    total = total + 1
    if p.is_loaded then
      loaded = loaded + 1
    end
  end
  return { total = total, loaded = loaded }
end

function pm.show()
  local groups = { loaded = {}, not_loaded = {}, disabled = {} }
  for _, p in pairs(plugins) do
    if p.enabled == false then
      table.insert(groups.disabled, p.name)
    elseif p.is_loaded then
      table.insert(groups.loaded, p.name)
    else
      table.insert(groups.not_loaded, p.name)
    end
  end

  local lines = {}
  local function add_group(label, list)
    table.sort(list)
    table.insert(lines, label .. " (" .. #list .. ")")
    for _, name in ipairs(list) do
      table.insert(lines, "  " .. name)
    end
    table.insert(lines, "")
  end

  add_group("loaded", groups.loaded)
  add_group("not loaded", groups.not_loaded)
  add_group("disabled", groups.disabled)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local width = 40
  local height = math.min(#lines, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " plugins ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })
end

vim.api.nvim_create_user_command("Plugins", pm.show, {})

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update {}
end, {})

return pm
