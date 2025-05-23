local wrap_keys = require "utils.wrap_keys"

return {
  "pwntester/octo.nvim",
  cmd = { "Octo" },
  keys = wrap_keys {
    { "<leader>gn",  ":Octo notification list<CR>", desc = "Github Notifications" },
    { "<leader>gln", ":Octo notification list<CR>", desc = "Github Notifications" },
    { "<leader>glp", ":Octo pr list<CR>",           desc = "Github PRs" },
    { "<leader>glw", ":Octo run list<CR>",          desc = "Github Workflow runs" },
    { "<leader>gld", ":Octo discussion list<CR>",   desc = "Github Discussions" },
    { "<leader>gli", ":Octo issue list<CR>",        desc = "Github Issues" },
    { "<leader>glr", ":Octo repo list<CR>",         desc = "Github repos" },
  },
  opts = {
    mappings = {
      pull_request = {
        merge_pr = { lhs = "<leader>pm", desc = "Merge PR" },
        notification = {
          read = { lhs = "<leader>nr", desc = "mark notification as read" },
          done = { lhs = "<leader>nd", desc = "mark notification as done" },
          unsubscribe = { lhs = "<leader>nu", desc = "unsubscribe from notifications" },
        },
      },
    },
  },
}
