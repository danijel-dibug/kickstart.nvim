-- Global autocommands. Buffer-local filetype tweaks live in after/ftplugin/.
-- See :help lua-guide-autocommands

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local core = augroup('core', { clear = true })

-- Flash the yanked text. Try `yap`. See :help vim.hl.on_yank()
autocmd('TextYankPost', {
  group = core,
  desc = 'Highlight the yanked region',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reopen files at the last cursor position.
autocmd('BufReadPost', {
  group = core,
  desc = 'Restore the cursor position of a previously edited file',
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Terminal buffers are for running things, not for reading code.
autocmd('TermOpen', {
  group = core,
  desc = 'Clean up terminal buffers and enter insert mode',
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.spell = false
    vim.bo.swapfile = false
    vim.bo.bufhidden = 'hide'
    vim.cmd.startinsert()
  end,
})

-- Windows that only exist to be read should close with `q`.
autocmd('FileType', {
  group = core,
  desc = 'Close read-only helper windows with q',
  pattern = { 'help', 'qf', 'checkhealth', 'man', 'lspinfo' },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = event.buf, desc = 'Close window' })
  end,
})
