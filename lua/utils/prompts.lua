return {

  ['Make more readable'] = {
    strategy = 'inline',
    opts = { modes = { 'v' }, shortname = 'readable' },
    description = 'Make Code more readable',
    prompts = {
      { role = 'system', content = export },
      {
        role = 'user',
        content = 'Make this code more readable, so that non developer could also understand this.',
      },
    },
  },

  ['Search errors'] = {
    strategy = 'chat',
    description = 'Search for potentially errors in code',
    opts = {
      modes = { 'v' },
      short_name = 'error',
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = true,
    },
    prompts = {
      { role = 'system', content = export },
      {
        role = 'user',
        content = function(context)
          local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
          return 'I have the following code, what are the potential errors there might be in this code:\n\n```'
            .. context.filetype
            .. '\n'
            .. code
            .. '\n```\n\n'
        end,
        opts = { contains_code = true },
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
            return 'Git diff is not available it is problem from user please provide proper explanation to user, error recived is' .. m.message
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
        opts = { contains_code = true },
      },
    },
  },
}
