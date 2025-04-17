local git_repo = function()
  local repo_url = vim.fn.system 'git config --get remote.origin.url'
  if repo_url and repo_url ~= '' then
    repo_url = vim.fn.trim(repo_url)
    return 'Currently user is editing github repo: ' .. repo_url
  end
  return ''
end

return {

  ['mcp'] = {
    callback = require 'mcphub.extensions.codecompanion',
    description = 'Call all MCP tools and resources',
  },
  ['github'] = {
    callback = require 'plugins.ai.mcphub.get_tool'(
      'github',
      "You can access tools regarding github. User's github id is bibekbhusal0"
        .. git_repo(),
      false
    ),
    description = 'MCP: Github actions',
  },
  ['figma'] = {
    callback = require 'plugins.ai.mcphub.get_tool'(
      { 'figma', 'TalkToFigma' },
      'You can change figma design with TalkToFigma and get figma data and download images with figma MCP server',
      true
    ),
    description = 'MCP: Figma downloader and talk to figma',
  },
  ['duck'] = {
    callback = require 'plugins.ai.mcphub.get_tool'(
      'duckduckgo',
      'if user asks you something you do not know feel free to search it change max results as required',
      true
    ),
    description = 'MCP: DuckDuckGo search',
  },
  ['notion'] = {
    callback = require 'plugins.ai.mcphub.get_tool'(
      { 'notion', 'notion-page' },
      'If user says to run multiple commands or to taks all at once follow the user. Follow the user if user says to run multiple commands at once',
      true
    ),
    description = 'MCP: Notion',
  },
}
