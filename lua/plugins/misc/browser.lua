local wrap_keys = require 'utils.wrap_keys'

local escape_target = function(target)
  local escapes = {
    [' '] = '%20',
    ['<'] = '%3C',
    ['>'] = '%3E',
    ['#'] = '%23',
    ['%'] = '%25',
    ['+'] = '%2B',
    ['{'] = '%7B',
    ['}'] = '%7D',
    ['|'] = '%7C',
    ['\\'] = '%5C',
    ['^'] = '%5E',
    ['~'] = '%7E',
    ['['] = '%5B',
    [']'] = '%5D',
    ['‘'] = '%60',
    [';'] = '%3B',
    ['/'] = '%2F',
    ['?'] = '%3F',
    [':'] = '%3A',
    ['@'] = '%40',
    ['='] = '%3D',
    ['&'] = '%26',
    ['$'] = '%24',
  }
  return target:gsub('.', escapes)
end

local function search(format, icon, title)
  require 'utils.input'(title, function(text)
    require('browse.utils').default_search(format:format(escape_target(text)))
  end, '', 50, icon .. '  ')
end

local function searchYoutube()
  search('https://www.youtube.com/results?search_query=%s', '', 'youtube')
end

return {
  {
    'dhruvmanila/browser-bookmarks.nvim',
    keys = wrap_keys { { '<leader>B', ':BrowserBookmarks<CR>', desc = 'Search Browser Bookmarks' } },
    cmd = { 'BrowserBookmarks' },
    config = function()
      require('telescope').load_extension 'bookmarks'
      require('browser_bookmarks').setup {
        profile_name = 'Bibek',
        url_open_command = 'start ""',
      }
    end,
  },

  {
    'lalitmee/browse.nvim',
    keys = wrap_keys {
      { '<leader>rf', ":lua require('browse.devdocs').search_with_filetype()<CR>", desc = 'Search DevDocs for this' },
      { '<leader>rF', ":lua require('browse.devdocs').search()<CR>", desc = 'Search DevDocs' },
      { '<leader>ry', searchYoutube, desc = 'Search Youtube' },
      { '<leader>rj', ":lua require('browse').browse()<CR>", desc = 'Search any' },
      { '<leader>rb', ":lua require('browse').open_bookmarks()<CR>", desc = 'Search Bookmarks' },
      { '<leader>ri', ":lua require('browse').input_search()<CR>", desc = 'Search' },
    },

    opts = {
      bookmarks = {
        ['github'] = {
          ['name'] = 'Web-based version control',
          ['code_search'] = 'https://github.com/search?q=%s&type=code',
          ['repo_search'] = 'https://github.com/search?q=%s&type=repositories',
          ['issues_search'] = 'https://github.com/search?q=%s&type=issues',
          ['pulls_search'] = 'https://github.com/search?q=%s&type=pullrequests',
        },
        ['youtube'] = {
          ['name'] = 'Youtube',
          ['search'] = 'https://www.youtube.com/results?search_query=%s',
          ['channel'] = 'https://www.youtube.com/results?search_query=%s&sp=EgIQAg%253D%253D',
          ['video'] = 'https://www.youtube.com/results?search_query=%s&sp=EgIQAQ%253D%253D',
          ['music'] = 'https://music.youtube.com/search?q=%s',
        },
        ['spotify'] = {
          ['name'] = 'Music and podcast',
          ['search'] = 'https://open.spotify.com/search/%s',
          ['songs'] = 'https://open.spotify.com/search/%s/tracks',
          ['artists'] = 'https://open.spotify.com/search/%s/artists',
          ['albums'] = 'https://open.spotify.com/search/%s/albums',
          ['playlists'] = 'https://open.spotify.com/search/%s/playlists',
          ['podcast'] = 'https://open.spotify.com/search/%s/podcastAndEpisodes',
        },
        ['neovim'] = {
          ['S-dotfyle'] = 'https://dotfyle.com/neovim/plugins/trending',
          ['dotfyle'] = 'https://dotfyle.com/neovim/plugins/trending?page=1&q=%s',
          ['reddit'] = 'https://www.reddit.com/r/neovim/search/?q=%s',
          ['S-awesome'] = 'https://github.com/rockerBOO/awesome-neovim',
        },
        ['ai'] = {
          ['t3-chat'] = 'https://www.t3.chat/new?q=%s',
          ['perplexity'] = 'https://www.perplexity.ai/?q=%s',
          ['chat-gpt'] = 'https://chat.openai.com/?q=%s',
          ['duck.ai'] = 'https://duckduckgo.com/?q=%s&ia=chat&bang=true',
        },
      },

      provider = 'duckduckgo',
      icons = {
        bookmark_alias = ' ',
        bookmarks_prompt = ' ',
        grouped_bookmarks = ' ',
      },
    },
  },
}
