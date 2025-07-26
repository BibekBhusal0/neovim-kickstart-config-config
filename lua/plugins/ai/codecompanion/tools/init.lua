local M = {}
local core = require "mcphub.extensions.codecompanion.core"

local function create_static_handler(action_name, has_function_calling, opts)
  return function(agent, args, _, output_handler)
    local context = {
      tool_display_name = action_name,
      is_individual_tool = false,
      action = action_name,
    }
    core.execute_mcp_tool(args, agent, output_handler, context)
  end
end

local schema = {
  type = "function",
  ["function"] = {
    name = "use_mcp_tool",
    description = "calls tools on MCP servers.",
    parameters = {
      type = "object",
      properties = {
        server_name = {
          description = "Name of the server to call the tool on. Must be from one of the available servers.",
          type = "string",
        },
        tool_name = {
          description = "Name of the tool to call.",
          type = "string",
        },
        tool_input = {
          description = "Input object for the tool call",
          type = "object",
        },
      },
      required = {
        "server_name",
        "tool_name",
        "tool_input",
      },
      additionalProperties = false,
    },
    strict = false,
  },
}

local opts =
  { enabled = true, make_slash_commands = true, make_vars = true, show_result_in_chat = true }
local has_function_calling = true

function M.get_tool(name, all_servers)
  local tools = {
    groups = {
      [name] = {
        description = "MCP Servers Tool for " .. name,
        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          local prompt_utils = require "mcphub.utils.prompt"
          if not hub then
            vim.notify("MCP Hub is not initialized", vim.log.levels.WARN)
            return ""
          end
          local prompt = ""
          local mcp_servers = hub:get_servers(true)
          local servers_needed = {}
          local servers = all_servers or { name }
          for _, n in ipairs(servers) do
            for _, server in ipairs(mcp_servers) do
              if server.name == n then
                table.insert(servers_needed, server)
                if server.status == "disabled" then
                  hub:start_mcp_server(server.name)
                end
              end
            end
          end
          prompt = prompt .. prompt_utils.get_active_servers_prompt(servers_needed, true, true)
          return prompt
        end,
        tools = {},
      },
    },
  }

  local action_name = "use_mcp_tool"
  tools[action_name] = {
    description = schema["function"].description,
    visible = false,
    callback = {
      name = action_name,
      cmds = { create_static_handler(action_name, has_function_calling, opts) },
      system_prompt = function()
        return string.format(
          "You can use the %s tool to %s\n",
          action_name,
          schema["function"].description
        )
      end,
      output = core.create_output_handlers(action_name, has_function_calling, opts),
      schema = schema,
    },
  }
  table.insert(tools.groups[name].tools, action_name)
  return tools
end

function M.setup()
  local ok, cc_config = pcall(require, "codecompanion.config")
  if not ok then
    return
  end

  local all_tools = {
    { name = "duck", args = { "duckduckgo" } },
    { name = "figma", args = { "figma", "TalkToFigma" } },
    { name = "notion", args = { "notion", "notion-page" } },
    { name = "chess" },
    { name = "github" },
    { name = "obsidian" },
  }

  for _, tool_config in ipairs(all_tools) do
    cc_config.strategies.chat.tools = vim.tbl_deep_extend(
      "force",
      cc_config.strategies.chat.tools,
      M.get_tool(tool_config.name, tool_config.args)
    )
  end
end

return M
