-- Keymaps and autocommands for buffers that have a language client attached.
-- The `gr` prefix is kept from the previous setup.

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  desc = 'Set up LSP keymaps and document highlighting',
  callback = function(event)
    local function map(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Navigation
    map('grd', Snacks.picker.lsp_definitions, '[G]oto [D]efinition')
    map('grr', Snacks.picker.lsp_references, '[G]oto [R]eferences')
    map('gri', Snacks.picker.lsp_implementations, '[G]oto [I]mplementation')
    map('grt', Snacks.picker.lsp_type_definitions, '[G]oto [T]ype definition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', Snacks.picker.lsp_symbols, 'Document [O]utline (symbols)')
    map('gW', Snacks.picker.lsp_workspace_symbols, 'Workspace symbols')

    -- Editing
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Docs
    map('K', vim.lsp.buf.hover, 'Hover documentation')
    map('gK', vim.lsp.buf.signature_help, 'Signature help')

    -- Highlight the occurrences of the symbol under the cursor on CursorHold,
    -- clear them as soon as the cursor moves.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local group = vim.api.nvim_create_augroup('lsp-document-highlight', { clear = false })

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = group,
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = group,
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
      -- Leave nothing behind when the client detaches from the buffer.
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(detach)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = group, buffer = detach.buf }
        end,
      })
    end

    -- Inlay hints are off by default; this only appears when the client can do it.
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
      end, '[T]oggle inlay [H]ints')
    end
  end,
})
