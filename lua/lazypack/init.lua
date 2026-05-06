local config = require "lazypack.config"
local cmd = require "lazypack.cmd"
local events = require "lazypack.events"
local build = require "lazypack.build"
local pack = require "lazypack.pack"
local utils = require "lazypack.utils"

local function load_on_key(plugin, run_config_once)
  if not plugin.keys then
    return
  end
  print "loading if key pressed"
  for _, map in ipairs(plugin.keys) do
    local lhs, rhs = map[1], map[2]
    local mode = map.mode or "n"

    if not rhs then
      -- :TODO: Loading plugin right away for now
      -- it should load plugin and only on keymap
      run_config_once()
    else
      vim.keymap.set(mode, lhs, function()
        run_config_once()
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

local M = {}
local augroup = vim.api.nvim_create_augroup("lazypack", { clear = false })

--- @alias AddOpts string|PluginSpec|(string | PluginSpec)[]

--- @class PluginSpec
-- [1]: string           src — "user/repo" or full https URL
---@diagnostic disable-next-line: undefined-doc-name
--- @field version? string|vim.version.range
--- @field name? string
--- @field init? fun()
--- @field config? boolean|fun()
--- @field opts? table|fun():table
--- @field event? string|string[]
--- @field cmd? string|string[]
--- @field dependencies? string|string[]
--- @field enabled? boolean|fun():boolean
--- @field build? string|fun(ev: table)|(string|fun(ev: table))[]
--- @field lazy? boolean
--- @field keys? table

--- @param plugins AddOpts
function M.add_plugin(plugins)
  build.ensure_build_hooks(augroup)

  local list = utils.normalize_plugins_input(plugins)

  for _, plugin in ipairs(list) do
    if type(plugin) == "string" then
      vim.pack.add { utils.normalize_source(plugin) }
    elseif type(plugin) == "table" then
      if config.is_enabled(plugin) then
        plugin.src = plugin[1]
        local normalized_src = utils.normalize_source(plugin.src)

        if plugin.dependencies then
          local dependencies = utils.to_list(plugin.dependencies)
          for _, dependency in ipairs(dependencies) do
            if type(dependency) == "string" then
              vim.pack.add { utils.normalize_source(dependency) }
            else
              vim.notify(
                ("Skipping dependency for `%s`: expected string, got %s"):format(
                  plugin.name or "unknown plugin",
                  type(dependency)
                ),
                vim.log.levels.WARN
              )
            end
          end
        end

        vim.pack.add({
          {
            src = normalized_src,
            name = plugin.name,
            version = plugin.version,
            data = {
              init = plugin.init,
              config = plugin.config,
              opts = plugin.opts,
              event = plugin.event,
              cmd = plugin.cmd,
              build = plugin.build,
              lazy = plugin.lazy,
              keys = plugin.keys,
            },
          },
        }, {
          load = function(p)
            local data = p.spec.data or {}
            local run_config_once = config.run_config_once_factory(p, data)

            if type(data.init) == "function" then
              data.init()
            end

            if not utils.is_lazy(data) then
              run_config_once()
              return
            end

            cmd.register_cmd_lazy_load(p, data, run_config_once)
            events.register_event_lazy_load(p, data, run_config_once, augroup)
            load_on_key(data, run_config_once)
          end,
        })
      end
    end
  end
end

function M.add_plugins(list)
  vim.validate { list = { list, "table" } }
  for _, plugin in ipairs(list) do
    if type(plugin) == "string" then
      M.add_plugin { plugin }
    elseif type(plugin) == "table" then
      if type(plugin[1]) == "string" then
        M.add_plugin(plugin)
      elseif type(plugin[1]) == "table" then
        M.add_plugins(plugin)
      end
    end
  end
end

M.pack_clean = pack.clean
M.pack_update = pack.update

return M
