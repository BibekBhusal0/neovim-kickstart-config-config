local save_to_desktop = function()
  local sil = require 'nvim-silicon'
  local options = vim.tbl_deep_extend('force', sil.options, {})
  options.output = os.getenv 'USERPROFILE' .. '/Desktop/code/' .. os.date '!%Y-%m-%dT%H-%M-%SZ' .. '_code.png'
  sil.shoot(options)
end

return {
  'michaelrommel/nvim-silicon',
  cmd = 'Silicon',
  keys = {
    { '<leader>cs', ':Silicon<cr>', desc = 'Screenshot to Root directory', mode = { 'n', 'v' }, silent = true },
    { '<leader>cS', ":lua require('nvim-silicon').clip()<CR>", desc = 'Screenshot to clipboard', mode = { 'n', 'v' }, silent = true },
    { '<leader>cd', save_to_desktop, desc = 'Screenshot to Desktop', mode = { 'n', 'v' }, silent = true },
  },

  main = 'nvim-silicon',
  opts = {
    line_offset = function(args)
      if args.range == 0 or args.range == nil then
        return 1
      end
      return args.line1
    end,
    font = 'JetBrainsMono Nerd Font',
    theme = 'DarkNeon',
    -- background = '#f76161',
    shadow_blur_radius = 14,
    shadow_offset_x = 20,
    shadow_offset_y = 20,
    shadow_color = '#27272a',
    background_image = os.getenv 'USERPROFILE' .. '/AppData/Local/nvim/gradient.png',
    num_separator = '\u{258f} ',
    window_title = function()
      return '    ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
    end,
  },
}
