return function(opts)
  local sil = require 'nvim-silicon'
  local options = vim.tbl_deep_extend('force', sil.options, opts)
  sil.shoot(options)
end
