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

opt.tabstop = 4
opt.shiftwidth = 4

opt.more = false

opt.foldmethod = 'manual'

opt.spell = true -- Enable spellchecking
opt.spelllang = 'en,hr' -- Set languages

return {
  require('mini.comment').setup {
    options = {
      -- Add a space after the comment characters
      pad_comment_parts = true,
    },
  },
}
