-- Markdown rendering, and Quarto notebooks (R/Python/Bash chunks with real LSP
-- support through otter.nvim).
local Pack = require 'core.pack'

Pack.add {
  Pack.gh 'MeanderingProgrammer/render-markdown.nvim',
  Pack.gh 'quarto-dev/quarto-nvim',
  Pack.gh 'jmbuhr/otter.nvim',
}

-- Render headings, lists, tables, code blocks and math in place.
require('render-markdown').setup {
  -- Render in every mode so that switching modes does not force a redraw.
  render_modes = true,
  debounce = 150,
  -- Keep the text under and around the cursor unhidden while typing.
  anti_conceal = {
    enabled = true,
    above = 1,
    below = 1,
    ignore = { code_background = true, indent = true, sign = true, virtual_lines = true },
  },
  win_options = {
    conceallevel = { default = vim.o.conceallevel, rendered = 3 },
    concealcursor = { default = vim.o.concealcursor, rendered = '' },
  },
  -- Complete heading names and links through LSP/otter.
  completions = { lsp = { enabled = true } },
}

vim.keymap.set('n', '<leader>tm', function()
  require('render-markdown.api').toggle()
end, { desc = '[T]oggle [M]arkdown rendering' })

-- Quarto: .qmd files. `lspFeatures` makes the code chunks look like ordinary
-- Python/Bash to the language servers.
require('quarto').setup {
  lspFeatures = {
    enabled = true,
    languages = { 'python', 'bash' },
    diagnostics = { enabled = true },
  },
}
