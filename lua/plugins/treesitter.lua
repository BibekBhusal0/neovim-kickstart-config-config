return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.install').compilers = { 'zig' }
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'lua',
        'python',
        'javascript',
        'typescript',
        'tsx',
        'css',
        'html',
        'vimdoc',
        'vim',
        'json',
        'gitignore',
        'markdown',
        'bash',
      },
      auto_install = true,
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true },
    }
  end,
}
