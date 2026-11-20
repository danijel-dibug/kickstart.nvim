-- Small editing building blocks, all from mini.nvim.
--
-- Not here on purpose:
--   * commenting: built into Neovim since 0.10 as `gc` (:help commenting)
--   * autopairs:  mini.pairs below replaces nvim-autopairs
--   * indent guides: snacks.indent, see lua/plugins/snacks.lua
local Pack = require 'core.pack'

Pack.add { Pack.gh 'nvim-mini/mini.nvim' }

-- Icons. Replaces nvim-web-devicons and mocks that module for plugins which
-- still require it by name (lualine).
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  require('mini.icons').mock_nvim_web_devicons()
end

-- `ia)` `aa"` `if` ... : better `inside/around` text objects.
local MiniAi = require 'mini.ai'
MiniAi.setup {
  n_lines = 500,
  custom_textobjects = {
    -- Treesitter backed function/class text objects where a parser is
    -- available, instead of mini.ai's heuristics. `iaa`/`aaa` (arguments) and
    -- the bracket/quote text objects are already built into mini.ai.
    f = MiniAi.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    c = MiniAi.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
  },
}

-- `sa)iw` `sd"` `sr"'` : add / delete / replace surrounding characters.
require('mini.surround').setup()

-- Auto-close brackets, quotes and tags while typing.
require('mini.pairs').setup()
