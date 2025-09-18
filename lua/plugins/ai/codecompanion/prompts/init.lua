local system_prompts = require "plugins.ai.codecompanion.prompts.system"

return {

  ["Make more readable"] = {
    strategy = "inline",
    opts = { modes = { "v" }, shortname = "readable" },
    description = "Make Code more readable",
    prompts = {
      { role = "system", content = system_prompts.readable, opts = { visible = false } },
      {
        role = "user",
        content = "Make this code more readable, so that non developer could also understand this.",
      },
    },
  },

  ["Straight forward model"] = {
    strategy = "chat",
    description = "Super straight forward model which will just provide code",
    opts = { ignore_system_prompt = true, short_name = "straight" },
    prompts = {
      {
        role = "system",
        content = system_prompts.straight,
        opts = { visible = false, auto_submit = true, tag = "system_tag" },
      },
      {
        role = "user",
        content = "",
        opts = { auto_submit = false },
      },
    },
  },

  ["New chat"] = {
    strategy = "chat",
    description = "new",
    opts = { short_name = "new", modes = { "v" } },
    prompts = {
      {
        role = "user",
        content = "",
        opts = { auto_submit = false },
      },
    },
  },

  ["Smart Paste"] = {
    strategy = "inline",
    description = "Paste code smartly",
    opts = {
      index = 12,
      short_name = "paste",
      adapter = { name = "gemini", model = "gemini-1.5-flash" },
    },
    prompts = {
      { role = "user", content = system_prompts.paste },
      {
        role = "user",
        content = function(context)
          local lines = require("codecompanion.helpers.actions").get_code(
            1,
            context.line_count,
            { show_line_numbers = true }
          )
          local selection_info = ""
          local clipboard = vim.fn.getreg "+"

          if context.is_visual then
            selection_info =
              string.format("Currently selected lines: %d-%d", context.start_line, context.end_line)
          else
            selection_info = string.format(
              "Current cursor line: %d and Current cursor column is %d",
              context.cursor_pos[1],
              context.cursor_pos[2]
            )
          end

          return string.format(
            "I have the following code:\n\n```%s\n%s\n```\n\nClipboard content:\n\n```\n%s\n```\n\n%s",
            context.filetype,
            lines,
            clipboard,
            selection_info
          )
        end,
        opts = { contains_code = true },
      },
    },
  },
}
