-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- vim.o.guicursor = 'n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'

-- Ask yourself do you really want to rob yourself from having macros
-- vim.keymap.set('n', 'Q', '<nop>')
-- vim.keymap.set('n', 'q', '<nop>')

-- move visual selected block or line
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.wo.relativenumber = true

return {
  'tpope/vim-fugitive',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sections = {
        lualine_x = { { 'filetype', icon_only = true } },
      },
      options = {
        icons_enabled = true,
        theme = 'onedark',
        -- component_separators = '|',
        -- section_separators = '',
        -- section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
    },
  },
  'nvim-treesitter/nvim-treesitter-context',
}
