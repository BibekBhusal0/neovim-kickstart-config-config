return {

  ["Make more readable"] = {
    strategy = "inline",
    opts = { modes = { "v" }, shortname = "readable" },
    description = "Make Code more readable",
    prompts = {
      {
        role = "system",
        content = "only change code according to user command and make sure you complete code and if you are not able to make change just give user's code as it is",
        opts = { visible = false },
      },
      {
        role = "user",
        content = "Make this code more readable, so that non developer could also understand this.",
      },
    },
  },

  ["Straight forward model"] = {
    strategy = "chat",
    description = "Super straight forward model which will just provide code",
    opts = {
      auto_submit = false,
      ignore_system_prompt = true,
      short_name = "straight",
    },
    prompts = {
      {
        role = "system",
        content = [[
You are a super straight forward model which will provide code to user or solve user problem based on user input.
Currently you are trapped in Neovim in user's machine, your task is to solve user's problem.
Aside from coading you will not be able to do anything else.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user's context is outside your core tasks.
- Minimize additional prose unless clarification is needed.
- Use Markdown formatting in your answers unless specified by user.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Avoid using H1 and H2 headers in your responses.
- Explain changes in simple words so that user can understand.

Your reply must:
- Contain code unelss specified by user.
- Only show code you have modified.
- Explain changes if you have made

You must not:
- Give very long response.
- Talk about anything except programming.
        ]],
        opts = { visible = false, tag = "system_tag" },
      },
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
      -- placement = 'add',
      index = 12,
      short_name = "paste",
      ignore_system_prompt = false,
      adapter = {
        name = "gemini",
        model = "gemini-1.5-flash", -- supposed to be fast
      },
    },
    prompts = {
      {
        role = "user",
        content = [[
You are a smart code paste agent within Neovim.

## **Task:** Intelligently integrate content from the user's clipboard into the current buffer.

## **Instructions:**

-   You may receive code in various programming languages or even natural language instructions.
-   If the clipboard content is in a different language than the current buffer, translate it to the appropriate language smartly.
-   If the clipboard content contains psudo code generate code accordingly.
-   If the clipboard content contains natural language instructions, interpret and follow them to modify the code in the current buffer.
-   **ONLY** generate the **new** lines of code required for seamless integration.
-   Ensure the inserted code is syntactically correct and logically consistent with the existing code.
-   Do **NOT** include surrounding code or line numbers.
-   Make sure all brackets and quotes are closed properly.

## **Output:**

-   Provide only the necessary lines of code for insertion.
-   If you can't generate code just return nothing.
-   Ensure the response is proper and well-formatted.
 ]],
      },
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
        opts = {
          contains_code = true,
        },
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
      adapter = {
        name = "gemini",
        model = "gemini-1.5-flash", -- supposed to be fast
      },
    },
    prompts = {
      {
        role = "system",
        opts = { visible = false, tag = "system_tag" },
        content = [[
      # you are export in creating git commit Message based on git diff provided
      if user has not provided git diff than you should help user with their problem
      you will provide short and to the point commit message
      while generating commit message are encouraged use emoji if and only use them if it make sense
      while generating commit message you will only return commit message nothing else not even discription or explanation of changes
      generated commit message should be less than 60 characters in any case
      and don't return commit message in markdown code block
      ]],
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
          return string.format(
            [[ Given the git diff listed below, please generate a commit message for me:
```diff
%s
```
]],
            diff
          )
        end,
        opts = { contains_code = true, visible = false },
      },
    },
  },
}
