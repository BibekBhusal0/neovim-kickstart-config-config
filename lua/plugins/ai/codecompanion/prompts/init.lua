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
    opts = { auto_submit = false, ignore_system_prompt = true, short_name = "straight" },
    prompts = {
      {
        role = "system",
        content = system_prompts.straight,
        opts = { visible = false, tag = "system_tag" },
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

  ["Generate a Commit Message"] = {
    strategy = "chat",
    description = "Generate a commit message",
    condition = function()
      return require "plugins.ai.diff"().ok
    end,
    opts = {
      index = 10,
      is_default = true,
      is_slash_cmd = false,
      short_name = "commit",
      auto_submit = true,
      ignore_system_prompt = true,
      adapter = { name = "gemini", model = "gemini-1.5-flash" },
    },
    prompts = {
      {
        role = "system",
        opts = { visible = false, tag = "system_tag" },
        content = system_prompts.commit,
      },
      {
        role = "user",
        content = function()
          local m = require "plugins.ai.diff"()
          if not m.ok then
            return "Git diff is not available, please help to user by providing step by step instructions what they need to do. The reason why git diff is not available is "
              .. m.message
          end
          local diff = m.message
          local commit_messages = vim.fn.system "git log -n 5 --pretty=format:%s"
          local error_found = string.find(commit_messages, "^error")
          local formatted_commit_messages = ""
          if not error_found then
            if commit_messages ~= "" then
              formatted_commit_messages = "Fore more context I will provide you last 5 commit messages:\n"
                .. commit_messages
            end
          end
          return string.format(
            "Given the git diff listed below, please generate a commit message for me:\n\n ```diff\n%s\n ```\n%s",
            diff,
            formatted_commit_messages
          )
        end,
        opts = { contains_code = true, visible = false },
      },
    },
  },
}
