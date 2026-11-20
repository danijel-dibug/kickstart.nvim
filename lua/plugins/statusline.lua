-- Statusline.
--
-- 'mini.statusline' and snacks' statuscolumn are alternatives; lualine stays
-- because its sections are exactly what is wanted here: relative path in the
-- middle, filetype icon at the right end.
local Pack = require 'core.pack'

Pack.add { Pack.gh 'nvim-lualine/lualine.nvim' }

require('lualine').setup {
  options = {
    theme = 'auto', -- follow the active colorscheme (tokyonight)
    icons_enabled = vim.g.have_nerd_font,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    globalstatus = vim.o.laststatus == 3,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
      { 'diagnostics' },
      { 'filename', path = 1 }, -- 1 = relative path
    },
    lualine_x = { { 'filetype', icon_only = true } },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  extensions = { 'quickfix', 'man', 'notifies' },
}
