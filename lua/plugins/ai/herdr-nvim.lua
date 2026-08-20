local wrap_keys = require "utils.wrap_keys"

local function send_comment(c, opts)
  local herdr = require "herdr-nvim"
  local comments = require "herdr-nvim.comments"
  local prompt = require "herdr-nvim.prompt"
  local agents = require "herdr-nvim.agents"
  local ui = require "herdr-nvim.ui"
  local dispatch = require "herdr-nvim.dispatch"

  local item = { comment = c, snippet = comments.snippet(c.id) }
  local cwd = c.file ~= "" and vim.fn.fnamemodify(c.file, ":h") or nil
  local text = prompt.format({ item }, { header_context = herdr._git_context(cwd) })
  local agent_list, err = agents.list()
  if not agent_list then
    vim.notify("herdr-nvim: " .. err, vim.log.levels.ERROR)
    return
  end
  ui.pick_agent(agent_list, function(agent)
    local ok, derr = dispatch.send(agent.pane_id, text, opts)
    if not ok then
      vim.notify("herdr-nvim: " .. derr, vim.log.levels.ERROR)
      return
    end
    if herdr.config.clear_after_send then
      herdr.delete_comment(c)
    end
    vim.notify(string.format("herdr-nvim: sent comment to %s", agent.title))
  end)
end

local function add_and_send(start_line, end_line)
  local comments = require "herdr-nvim.comments"
  local ui = require "herdr-nvim.ui"
  ui.input_comment(function(text)
    local id = comments.add(vim.api.nvim_get_current_buf(), start_line, end_line, text)
    ui.decorate(id)
    local c = comments.get(id)
    if c then
      send_comment(c, { submit = true })
    end
  end)
end

local function add_line_and_send()
  add_and_send(vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[1])
end

local function add_selection_and_send()
  vim.cmd [[execute "normal! \<esc>"]]
  local s, e = require("herdr-nvim.ui").visual_range()
  add_and_send(s, e)
end

return {
  {
    "ChmaraX/herdr-nvim",
    cond = function()
      return vim.env.HERDR_PANE_ID ~= nil
    end,
    keys = wrap_keys {
      {
        "<leader>an",
        function()
          require("herdr-nvim").comment_selection()
        end,
        desc = "Herdr-nvim Comment Selection",
        mode = "x",
      },
      {
        "<leader>an",
        function()
          require("herdr-nvim").comment_line()
        end,
        desc = "Herdr-nvim Comment Line",
        mode = "n",
      },
      {
        "<leader>al",
        function()
          require("herdr-nvim").list_comments()
        end,
        desc = "Herdr-nvim List Comments",
      },
      {
        "<leader>aP",
        function()
          require("herdr-nvim").send_all { submit = false }
        end,
        desc = "Herdr-nvim Paste Comments to Agent",
      },
      {
        "<leader>aS",
        function()
          require("herdr-nvim").send_all { submit = true }
        end,
        desc = "Herdr-nvim Send Comments to Agent",
      },
      { "<leader>am", add_line_and_send, desc = "Herdr-nvim Comment Send", mode = "n" },
      { "<leader>am", add_selection_and_send, desc = "Herdr-nvim Comment Send", mode = "x" },
    },
    opts = { keymaps = false },
  },
}
