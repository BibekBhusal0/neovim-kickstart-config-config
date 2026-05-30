local wrap_keys = require "utils.wrap_keys"

return {
  "lalitmee/browse.nvim",
  cmd = { "Browse" },
  keys = wrap_keys {
    {
      "<leader>rf",
      ":lua require('browse.devdocs').search_with_filetype()<CR>",
      desc = "Search DevDocs for this",
    },
    { "<leader>rF", ":lua require('browse.devdocs').search()<CR>", desc = "Search DevDocs" },
    {
      "<leader>ry",
      ":lua require('browse.utils').format_search('https://www.youtube.com/results?search_query=%s', {prompt = 'youtube: '})()<CR>",
      desc = "Search Youtube",
    },
    { "<leader>rj", ":Browse<CR>", desc = "Search any" },
    { "<leader>rb", ":Browse bookmarks_manual<CR>", desc = "Search Bookmarks" },
    {
      "<leader>ro",
      function()
        local file = vim.fn.expand "<cfile>"
        if file:match "https?://" then
          require("browse.utils").default_search(file)
        elseif file:match "^[%w%.%-]+/[%w%.%-_]+$" then
          require("browse.utils").default_search("https://github.com/" .. file)
        else
          local config = require "browse.config"
          local provider = config.opts.provider
          local word = vim.fn.expand "<cword>"
          local url = string.format("https://%s.com/search?q=%s", provider, word)
          if provider == "brave" then
            url = string.format("https://search.%s.com/search?q=%s", provider, word)
          elseif provider == "duckduckgo" then
            url = string.format("https://%s.com/?q=%s", provider, word)
          end
          require("browse.utils").default_search(url)
        end
      end,
      desc = "Open link or search",
    },
    { "<leader>ri", ":Browse input<CR>", desc = "Search" },
  },

  opts = {
    bookmarks = {
      ["github"] = {
        ["name"] = "Web-based version control",
        ["code_search"] = "https://github.com/search?q=%s&type=code",
        ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
        ["issues_search"] = "https://github.com/search?q=%s&type=issues",
        ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
      },
      ["youtube"] = {
        ["name"] = "Youtube",
        ["search"] = "https://www.youtube.com/results?search_query=%s",
        ["channel"] = "https://www.youtube.com/results?search_query=%s&sp=EgIQAg%253D%253D",
        ["video"] = "https://www.youtube.com/results?search_query=%s&sp=EgIQAQ%253D%253D",
        ["music"] = "https://music.youtube.com/search?q=%s",
      },
      ["spotify"] = {
        ["name"] = "Music and podcast",
        ["search"] = "https://open.spotify.com/search/%s",
        ["songs"] = "https://open.spotify.com/search/%s/tracks",
        ["artists"] = "https://open.spotify.com/search/%s/artists",
        ["albums"] = "https://open.spotify.com/search/%s/albums",
        ["playlists"] = "https://open.spotify.com/search/%s/playlists",
        ["podcast"] = "https://open.spotify.com/search/%s/podcastAndEpisodes",
      },
      ["neovim"] = {
        ["S-dotfyle"] = "https://dotfyle.com/neovim/plugins/trending",
        ["dotfyle"] = "https://dotfyle.com/neovim/plugins/trending?page=1&q=%s",
        ["reddit"] = "https://www.reddit.com/r/neovim/search/?q=%s",
        ["S-awesome"] = "https://github.com/rockerBOO/awesome-neovim",
      },
      ["ai"] = {
        ["t3-chat"] = "https://www.t3.chat/new?q=%s",
        ["perplexity"] = "https://www.perplexity.ai/?q=%s",
        ["chat-gpt"] = "https://chat.openai.com/?q=%s",
        ["duck.ai"] = "https://duckduckgo.com/?q=%s&ia=chat&bang=true",
      },
    },

    provider = "duckduckgo",
    icons = {
      bookmark_alias = " ",
      bookmarks_prompt = " ",
      grouped_bookmarks = " ",
    },
  },
}
