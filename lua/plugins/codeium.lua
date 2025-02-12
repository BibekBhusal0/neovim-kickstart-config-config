return {
   'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function ()
    vim.keymap.set('n' , '<leader>cc', '<cmd>Codeium Toggle<CR>', { noremap = true, silent = true } )

  end
}
