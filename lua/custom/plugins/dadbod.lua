return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { -- optional saghen/blink.cmp completion source
    'saghen/blink.cmp',
    optional = true,
    opts = function(_, opts)
      -- Ensure sources table exists
      opts.sources = opts.sources or {}
      opts.sources.per_filetype = opts.sources.per_filetype or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Add SQL-specific completions
      opts.sources.per_filetype.sql = { 'dadbod', 'buffer' }
      opts.sources.per_filetype.mysql = { 'dadbod', 'buffer' }
      opts.sources.per_filetype.plsql = { 'dadbod', 'buffer' }

      -- Add dadbod provider
      opts.sources.providers.dadbod = {
        name = 'Dadbod',
        module = 'vim_dadbod_completion.blink',
      }
      return opts
    end,
  },
}
