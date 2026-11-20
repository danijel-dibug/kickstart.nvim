-- Colourscheme. Loaded first so that every other module gets the right palette.
local Pack = require 'core.pack'

Pack.add { Pack.gh 'folke/tokyonight.nvim' }

require('tokyonight').setup {
  styles = {
    comments = { italic = false },
  },
  -- Lualine and other plugins pick the palette up automatically.
  plugins = {
    dashboards = false,
    pseudo = { italic = false },
  },
}

-- Other styles: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'.
-- Installed schemes: <leader>sc (see lua/plugins/snacks.lua).
vim.cmd.colorscheme 'tokyonight-night'
