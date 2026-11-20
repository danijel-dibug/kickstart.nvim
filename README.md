# Neovim configuration

Personal configuration for **Neovim 0.12+**. Plugins are managed by the built-in
[`vim.pack`](https://neovim.io/doc/user/pack.html#vim.pack), LSP is configured
with the native `vim.lsp.config` / `vim.lsp.enable`, and anything Neovim does
well on its own is not a plugin.

## Layout

```
init.lua                  bootstrap: leaders, then core, then plugin modules
nvim-pack-lock.json       plugin revisions (managed by vim.pack, commit it)

lua/core/                 no plugins in here, pure Neovim
  options.lua             every global option, the single place to change them
  keymaps.lua             global keymaps only
  autocmds.lua            global autocommands
  diagnostics.lua         how diagnostics look and how to jump between them
  pack.lua                vim.pack helpers (gh(), add()) and build hooks
  keymap.lua              helper for binding callable module tables

lua/plugins/              one file per concern, each declares its own plugins
  colorscheme.lua         tokyonight
  editing.lua             mini.nvim: icons, ai, surround, pairs
  snacks.lua              snacks.nvim: picker, explorer, terminal, notifier, ...
  ui.lua                  which-key, todo-comments, guess-indent
  statusline.lua          lualine
  mason.lua               what Mason installs (servers, formatters, CLI tools)
  treesitter.lua          parser install/attach, textobject queries, context line
  completion.lua          blink.cmp, lazydev, snippet and ghost text setup
  lsp/init.lua            capabilities, enable loop, fidget
  lsp/servers.lua         per-server settings
  lsp/keymaps.lua         LspAttach keymaps and document highlighting
  format.lua              conform.nvim formatters per filetype
  git.lua                 gitsigns, diffview, lazygit, fugitive
  dap.lua                 nvim-dap, dap-ui, Go and JVM debugging
  ai.lua                  minuet against a local llama.cpp server
  markdown.lua            render-markdown, quarto + otter
  db.lua                  vim-dadbod and its UI

after/ftplugin/           per-filetype options (native Neovim mechanism)
lua/myconfig/health.lua   `:checkhealth myconfig`
spell/                    English + Croatian word lists
```

## First launch

`vim.pack` installs everything declared by the plugin modules into
`~/.local/share/nvim/site/pack/core/opt`, then restart Neovim once
(`:restart`) so everything is loaded from disk.

Mason installs the language servers, formatters and the `tree-sitter` CLI in the
background (see `lua/plugins/mason.lua`). Treesitter parsers are installed on
startup and, for anything not listed there, automatically when you first open a
file of that type.

Sanity check after that:

```
:checkhealth myconfig blink.cmp vim.lsp snacks nvim-treesitter conform
```

## Managing plugins

| Task | Command |
| --- | --- |
| Update everything | `:lua vim.pack.update()` then `:w` to accept, `:q` to discard |
| Preview updates only | `:lua vim.pack.update(nil, { offline = true })` |
| Update one plugin | `:lua vim.pack.update({ 'snacks.nvim' })` |
| List installed plugins | `:lua vim.print(vim.pack.get())` |
| Remove a plugin | delete its spec from `lua/plugins/`, then `:lua vim.pack.del({ 'name' })` |
| Install a server/tool | `:Mason` or `:MasonInstall <name>` |

There is no lazy loading, so startup stays honest: about 100 ms with all plugins
below. If a plugin is only useful once a month, it does not belong here.

## Replaced by native Neovim

| Previously | Now |
| --- | --- |
| `mini.comment` | built-in `gc` operator (`:help commenting`) |
| `LuaSnip` | native `vim.snippet`, blink.cmp's default engine |
| `mason-lspconfig` handlers, `vim.lsp.*` boilerplate | `vim.lsp.config()` + `vim.lsp.enable()` |
| `nvim-lint` | LSP diagnostics (eslint/biome/gopls/pyright) |
| telescope.nvim + fzf + ui-select | `Snacks.picker` (`vim.ui.select` is wired to it too) |
| neo-tree.nvim | `Snacks.explorer()` |
| indent-blankline.nvim | `Snacks.indent` |
| nvim-autopairs | `mini.pairs` |
| nvim-web-devicons | `mini.icons` (mocks the old module for lualine) |
| snippet/navigation plugins | `vim.diagnostic.jump` (`]d`, `[d`), `K` for hover |

## Keybindings

`<Space>` is the leader; `which-key` shows the rest as you type.

**Files, search, buffers** (`Snacks.picker`)

| Keys | Action |
| --- | --- |
| `<leader><leader>` | buffers |
| `<leader>sf` / `<leader>s.` | files / recent files |
| `<leader>sg` / `<leader>sw` / `<leader>s/` | grep / grep word / grep open buffers |
| `<leader>/` | search in the current buffer |
| `<leader>so` | document outline (treesitter symbols) |
| `<leader>sd` / `<leader>st` | diagnostics / TODO comments |
| `<leader>ss` / `<leader>sr` | all pickers / resume last |
| `<leader>sh` / `<leader>sk` / `<leader>sc` | help / keymaps / colorschemes |
| `<leader>sm` / `<leader>sj` / `<leader>sy` | marks / jumps / registers |
| `<leader>sp` / `<leader>sn` | projects / this config's files |
| `<leader>e` or `\` | file explorer |
| `<leader>bd` | delete buffer (keeps the window layout) |
| `<leader>cR` | rename file on disk (LSP aware) |

**Editing and windows**

| Keys | Action |
| --- | --- |
| `<leader>w` / `<leader>q` | save / close window |
| `<leader>-` / `<leader>|` | split below / right |
| `<C-h>jkl>` / `<A-h>jkl>` | focus window / move window |
| `J` / `K` in visual mode | move the selection down / up |
| `<` / `>` in visual mode | indent and stay selected |
| `p` in visual mode | paste without clobbering the register |
| `jk` | leave insert mode |
| `gc` | comment (native), `]s` / `[s` misspelled word, `zg` add word |
| `if` / `af`, `ic` / `ac` | function / class text objects (treesitter backed) |

**LSP** (buffer local, see `lua/plugins/lsp/keymaps.lua`)

| Keys | Action |
| --- | --- |
| `grd` `grr` `gri` `grt` `grD` | definition / references / implementation / type definition / declaration |
| `grn` / `gra` | rename / code action |
| `gO` / `gW` | document symbols / workspace symbols |
| `K` / `gK` | hover / signature help |
| `<leader>th` | toggle inlay hints |
| `]d` / `[d`, `<leader>d`, `<leader>dl` | next / previous / float / location list |

**Git**

| Keys | Action |
| --- | --- |
| `<leader>gg` / `<leader>gl` / `<leader>gf` | lazygit / log / file log |
| `<leader>gd` / `<leader>gD` | diffview: working tree / recent commits |
| `<leader>gh` / `<leader>gH` | diffview: file history / repo history |
| `<leader>gs` / `<leader>gc` / `<leader>gb` / `<leader>gz` | status / commits / branches / stash |
| `<leader>gB` / `<leader>gp` | open in browser / inline hunk preview |
| `]c` / `[c` | next / previous hunk |
| `<leader>hs` `hr` `hS` `hR` `hu` `hp` `hb` `hd` `hD` `hq` `hQ` | stage, reset, previews, blame, quickfix |
| `<leader>tb` / `<leader>tw` | line blame / word diff |

**Formatting, debugging, AI**

| Keys | Action |
| --- | --- |
| `<leader>f` | format buffer (`<leader>f` also works in visual mode) |
| `F5` `F1` `F2` `F3` `F7` | continue / step in / over / out / debug UI |
| `<leader>b` / `<leader>B` | breakpoint / conditional breakpoint |
| `<A-y>` | AI completions in the completion menu |
| `<A-A>` `<A-a>` `<A-z>` | accept ghost text / to end of line / n lines |
| `<A-]>` `<A-[>` `<A-e>` | next / previous AI suggestion / dismiss |
| `<C-/>` | terminal |
| `<leader>z` / `<leader>Z` | zen mode / zoom window |
| `<leader>.` / `<leader>S` | scratch buffer / select scratch buffer |
| `<leader>n` / `<leader>un` | notification history / dismiss all |
| `<leader>tm` / `<leader>uc` | toggle markdown rendering / treesitter context |
| `<leader>db` / `<leader>dq` | database UI |

## Notes

- `lua/plugins/ai.lua` points minuet at a local llama.cpp server. Change
  `end_point` there for another host or model.
- Snippets are native: put your own in `~/.config/nvim/snippets/<ft>/*.snippet.json`
  and blink.cmp picks them up; language servers send their snippets the same way.
- Java debugging attaches to a JVM on port 5005
  (`-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005`).
- If you are migrating from the old lazy.nvim based version, the unused plugin
  directory can be removed after a few days of good behaviour:
  `rm -rf ~/.local/share/nvim/lazy`
