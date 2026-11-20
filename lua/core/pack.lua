-- Plugin management with the built-in `vim.pack` (:help vim.pack).
--
--   plugins on disk   ~/.local/share/nvim/site/pack/core/opt
--   lockfile          nvim-pack-lock.json (committed; treat it as config)
--
-- Commands, run them from Neovim:
--   :lua vim.pack.update()                                 update everything,
--                                                          review, `:w` to accept
--   :lua vim.pack.update(nil, { offline = true })          look, change nothing
--   :lua vim.pack.update({ 'snacks.nvim' })                update one plugin
--   :lua vim.pack.del({ 'plugin-name' })                   remove from disk
--   :lua vim.print(vim.pack.get())                         what is installed/active
--
-- Two things worth knowing about `vim.pack`:
--   * There is no lazy loading. Everything declared by the modules below is on
--     the runtimepath from startup, so only keep plugins here that you actually
--     want running.
--   * During init.lua, `vim.pack.add()` only puts a plugin on the runtimepath;
--     it does NOT source the plugin's `plugin/` scripts. `load = true` below
--     does that, otherwise pure Vimscript plugins (vim-dadbod, vim-fugitive)
--     would start up with no commands at all.

local M = {}

--- Shorthand for a GitHub repository.
---@param repo string e.g. 'folke/snacks.nvim'
---@return string
function M.gh(repo)
  return 'https://github.com/' .. repo
end

--- Install (if needed) and load plugins.
--- Accepts one spec, a string, or a list of either.
---@param spec vim.pack.Spec|string|(vim.pack.Spec|string)[]
function M.add(spec)
  if type(spec) == 'table' and spec.src then
    spec = { spec }
  end
  -- confirm = false: every spec is declared in this repository, there is
  -- nothing to ask about, and a fresh install would prompt once per module.
  vim.pack.add(spec, { load = true, confirm = false })
end

-- Build hooks, run after a plugin is installed or updated. :help vim.pack-events
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Run build steps for plugins that need them',
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' then
      -- The command comes from the plugin, so it has to be loaded first.
      if not event.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

return M
