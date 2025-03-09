return {

  ['Make more readable'] = {
    strategy = 'inline',
    opts = { modes = { 'v' }, shortname = 'readable' },
    description = 'Make Code more readable',
    prompts = {
      { role = 'system', content = export, opts = { visible = false } },
      {
        role = 'user',
        content = 'Make this code more readable, so that non developer could also understand this.',
      },
    },
  },

  ['Straight forward model'] = {
    strategy = 'chat',
    description = 'Super straight forward model which will just provide code',
    opts = {
      auto_submit = false,
      ignore_system_prompt = true,
      short_name = 'straight',
    },
    prompts = {
      {
        role = 'system',
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

Your reply must:
- Contain code unelss specified by user.
- Only show code you have modified.
- explain changes if you have made any

You must not:
- Give very long response.
- Talk about anything except programming.
        ]],
        opts = { visible = false, tag = 'system_tag' },
      },
      {
        role = 'user',
        content = '',
        opts = { auto_submit = false },
      },
    },
  },

  ['Generate a Commit Message'] = {
    strategy = 'chat',
    description = 'Generate a commit message',
    condition = function()
      m = require 'utils.diff'()
      return m.ok
    end,
    opts = {
      index = 10,
      is_default = true,
      is_slash_cmd = false,
      short_name = 'commit',
      auto_submit = true,
      ignore_system_prompt = true,
    },
    prompts = {
      {
        role = 'system',
        opts = { visible = false, tag = 'system_tag' },
        content = [[
      # you are export in creating git commit Message based on git diff provided
      if user has not provided git diff than you should help user with their problem
      you will provide short and to the point commit message 
      while generating commit message you should use emoji if and make sure used emoji make sense
      while generating commit message you will only return commit message nothing else not even discription or explanation of changes
      generated commit message should be less than 60 characters in any case
      and don't return commit message in markdown code block
      ]],
      },
      {
        role = 'user',
        content = function()
          local m = require 'utils.diff'()
          if not m.ok then
            return 'Git diff is not available, please help to user by providing step by step instructions what they need to do. The reason why git diff is not available is '
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
