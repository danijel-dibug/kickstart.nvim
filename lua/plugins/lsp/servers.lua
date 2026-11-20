-- Per-server LSP configuration.
--
-- Keys are LSP config names (see `:help lspconfig-all`, or the `lsp/*.lua`
-- files that nvim-lspconfig puts on the runtimepath). The table is a plain
-- `vim.lsp.Config`, so `cmd`, `filetypes`, `root_markers`, `settings`,
-- `init_options`, `on_init`, `on_attach` and `offset_encoding` are all valid.
--
-- Mason package names differ from these in places; they are listed in
-- lua/plugins/mason.lua.

---@type table<string, vim.lsp.Config>
return {
  -- Lua ----------------------------------------------------------------------
  -- Formatting is deliberately left to stylua (conform.nvim), otherwise lua_ls
  -- and stylua fight over the file.
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false

      -- Respect a project's own .luarc.json(c) if it has one; otherwise make
      -- Neovim's own runtime files available to the language server.
      local folder = client.workspace_folders and client.workspace_folders[1].name
      if folder and folder ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(folder .. '/.luarc.json') or vim.uv.fs_stat(folder .. '/.luarc.jsonc')) then
        return
      end

      local current = (client.config.settings or {}).Lua or {}
      client.config.settings.Lua = vim.tbl_deep_extend('force', current, {
        runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
        workspace = {
          checkThirdParty = false,
          -- Slow on huge runtimes, but needed to get completions for plugins.
          library = vim.api.nvim_get_runtime_file('', true),
        },
      })
    end,
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        format = { enable = false },
        diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },

  -- Go / Python / Rust -------------------------------------------------------
  gopls = {},
  pyright = {},
  rust_analyzer = {},

  -- JVM ----------------------------------------------------------------------
  jdtls = {
    init_options = {
      -- Debug adapter jars, used by jdtls to launch/attach debug sessions.
      bundles = vim.fs.find(function(name, path)
        return name:match '^com%.microsoft%.java%.debug%.plugin-%d.*%.jar$' and path:match 'java-debug-adapter/extension/server'
      end, {
        type = 'file',
        path = vim.fn.expand '~/.local/share/nvim/mason/packages/java-debug-adapter/extension/server',
        upward = false,
        limit = math.huge,
      }),
    },
  },

  -- Kotlin -------------------------------------------------------------------
  -- The JetBrains `kotlin-lsp` from Mason, not fwcd's `kotlin-language-server`
  -- (which is what the `kotlin` config name in nvim-lspconfig points at).
  -- It speaks UTF-16 positions and misreports its formatting capabilities, so
  -- ktlint does the formatting instead (see lua/plugins/format.lua).
  kotlin_lsp = {
    -- Mason's `kotlin-lsp` package installs the launcher as `intellij-server`.
    cmd = { vim.fn.executable 'intellij-server' == 1 and 'intellij-server' or 'kotlin-lsp' },
    filetypes = { 'kotlin' },
    root_markers = { 'settings.gradle', 'settings.gradle.kts', 'build.gradle', 'build.gradle.kts', '.git' },
    offset_encoding = 'utf-16',
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },

  -- Web ----------------------------------------------------------------------
  ts_ls = {},
  html = {},
  -- tailwindcss needs no configuration: the filetypes that nvim-lspconfig ships
  -- are the ones the language server itself recommends, and the server only
  -- answers in projects that actually have a tailwind config.
  emmet_language_server = {},

  -- JavaScript/TypeScript linting, plus Biome when a project uses it.
  eslint = {},
  biome = {},

  -- Other --------------------------------------------------------------------
  templ = {},
  zls = {},
}
