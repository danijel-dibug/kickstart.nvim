-- Configuration specific healthcheck. Run it with `:checkhealth myconfig`.
local health = vim.health

local M = {}

--- Report an external executable and what it is needed for.
---@param name string
---@param required boolean
---@param note string
local function tool(name, required, note)
  if vim.fn.executable(name) == 1 then
    health.ok(('%s found (%s)'):format(name, note))
  elseif required then
    health.error(('%s not found'):format(name), { note })
  else
    health.warn(('%s not found'):format(name), { note })
  end
end

function M.check()
  health.start 'Neovim'
  if vim.version.lt(vim.version(), { 0, 12, 0 }) then
    health.error('Neovim 0.12 or newer is required', {
      'This config uses vim.pack, vim.lsp.config/enable and native snippets, all of which need 0.12',
    })
  else
    health.ok(('Neovim %s'):format(tostring(vim.version())))
  end

  health.start 'External tools'
  tool('git', true, 'vim.pack installs and updates plugins with git')
  tool('rg', false, 'snacks.picker grep (<leader>sg) is much faster with ripgrep')
  tool('fd', false, 'snacks.picker files (<leader>sf) is much faster with fd')
  tool('lazygit', false, 'the git keymaps <leader>gg, <leader>gl and <leader>gf')
  tool('node', false, 'prettierd, eslint_d and the TypeScript language server')

  health.start 'Plugins (vim.pack)'
  local plugins = vim.pack.get()
  if #plugins == 0 then
    health.warn('no plugins are installed yet', { 'Restart Neovim so that vim.pack.add() can install them' })
  else
    health.ok(('%d plugins installed'):format(#plugins))
  end
  for _, plugin in ipairs(plugins) do
    if not plugin.active then
      health.warn(('%s is on disk but not loaded'):format(plugin.spec.name), {
        'Delete its spec from lua/plugins/ and run :lua vim.pack.del({ ' .. vim.inspect(plugin.spec.name) .. ' })',
      })
    end
  end
  if vim.uv.fs_stat(vim.fn.stdpath 'config' .. '/nvim-pack-lock.json') then
    health.ok 'nvim-pack-lock.json present (keep it under version control)'
  else
    health.warn('no nvim-pack-lock.json', { 'The lockfile pins plugin revisions across machines' })
  end

  health.start 'Treesitter'
  if vim.fn.executable 'tree-sitter' == 1 then
    health.ok 'tree-sitter CLI found (parsers can be compiled)'
  else
    health.error('tree-sitter CLI not found', {
      'Parsers cannot be compiled, so highlighting and indentation will be missing',
      'Run :MasonInstall tree-sitter-cli and restart',
    })
  end
  local ok, parsers = pcall(function()
    return require('nvim-treesitter').get_installed 'parsers'
  end)
  if not ok or #parsers == 0 then
    health.warn('no treesitter parsers installed', { 'Run :TSInstall <language>, or just open a file of that type' })
  else
    health.ok(('%d parsers installed'):format(#parsers))
  end

  health.start 'Fonts'
  if vim.g.have_nerd_font then
    health.info 'vim.g.have_nerd_font is set; install a Nerd Font if icons look broken'
  else
    health.info 'vim.g.have_nerd_font is not set; icons are replaced with ASCII'
  end
end

return M
