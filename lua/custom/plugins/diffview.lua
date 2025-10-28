return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'Git [D]iff View' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'Git File [H]istory' },
  },
}
