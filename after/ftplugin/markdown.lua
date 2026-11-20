-- Prose: wrap visually, never hard wrap at a column (render-markdown.nvim
-- renders the buffer and hard breaks would show up as content).
vim.bo.textwidth = 0
vim.wo.spell = true
vim.wo.wrap = true
vim.wo.linebreak = true
