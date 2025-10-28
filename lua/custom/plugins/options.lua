local opt = vim.o

----- Interesting Options -----

-- You have to turn this one on :)
opt.inccommand = 'split'

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- Personal Preferences -----
opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = 'yes'
-- opt.shada = { "'10", '<0', 's10', 'h' }

opt.swapfile = false

-- Don't have `o` add a comment
-- opt.formatoptions:remove 'o'

opt.wrap = true
opt.linebreak = true

opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2

opt.more = false

opt.foldmethod = 'manual'

opt.spell = true -- Enable spellchecking
opt.spelllang = 'en,hr' -- Set languages

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Better paste (don't yank replaced text)
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' })

return {
  require('mini.comment').setup {
    options = {
      -- Add a space after the comment characters
      pad_comment_parts = true,
    },
  },
}
