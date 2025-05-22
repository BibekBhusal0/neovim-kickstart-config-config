local wrap_keys = require "utils.wrap_keys"

local function searchYoutube()
  require("browse.utils").format_search(
    "https://www.youtube.com/results?search_query=%s",
    { prompt = "youtube" }
  )()
end

local function searchYTMusic()
  require("browse.utils").format_search(
    "https://music.youtube.com/search?q=%s",
    { prompt = "YT Music" }
  )()
end

local function open_github()
  local original_word = vim.fn.expand "<cWORD>"
  local cleaned_word = original_word
  local chars_to_remove = ",'\""
  while true do
    local original = cleaned_word
    cleaned_word = string.gsub(cleaned_word, "^[" .. chars_to_remove .. "]+", "")
    cleaned_word = string.gsub(cleaned_word, "[" .. chars_to_remove .. "]+$", "")
    if original == cleaned_word then
      break
    end
  end
  require("browse.utils").default_search("https://github.com/" .. cleaned_word)
end
local searchFiletype = ":lua require('browse.devdocs').search_with_filetype()<CR>"

return {
  {
    "dhruvmanila/browser-bookmarks.nvim",
    keys = wrap_keys { { "<leader>B", ":BrowserBookmarks<CR>", desc = "Search Browser Bookmarks" } },
    cmd = { "BrowserBookmarks" },
    dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
    config = function()
      require("browser_bookmarks").setup {
        profile_name = "Bibek",
        url_open_command = 'start ""',
      }
    end,
  },

  {
    "lalitmee/browse.nvim",
    keys = wrap_keys {
      { "<leader>gO", open_github, desc = "Open Github" },
      { "<leader>sb", ":lua require('browse').open_bookmarks()<CR>", desc = "Search Bookmarks" },
      { "<leader>sF", ":lua require('browse.devdocs').search()<CR>", desc = "Search DevDocs" },
      {
        "<leader>sf",
        searchFiletype,
        desc = "Search DevDocs for this",
      },
      { "<leader>si", ":lua require('browse').input_search()<CR>", desc = "Search" },
      { "<leader>sj", ":lua require('browse').browse()<CR>", desc = "Search any" },
      {
        "<leader>sm",
        searchYTMusic,
        desc = "Search Youtube Music",
      },
      { "<leader>sy", searchYoutube, desc = "Search Youtube" },
    },

    config = function()
      require("browse").setup {
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
      }
    end,
  },
}
