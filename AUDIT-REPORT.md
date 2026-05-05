# Neovim Config Audit — 2026-05-05

## 📊 Stats

| Metric | Value | Benchmark |
|--------|-------|-----------|
| Total plugins | **110** | Well-tuned configs: 30-60 |
| Startup time | **~600ms** | Goal: <100ms |
| Eager-loaded plugins (`lazy = false` / `VimEnter`) | **26** | Goal: <10 |
| Colorschemes loaded eagerly | **10** | Should be 1 |
| Abandoned plugins (>1 year no commits) | **7** | |

---

## 🔴 HIGH PRIORITY — Bloat / Abandoned

### 1. 10 colorschemes with `lazy = false` — biggest startup offender
Every colorscheme is loaded at startup. You use one at a time.

**Fix:** Add `lazy = true` to all colorschemes except your default. Lazy.nvim loads them on `:colorscheme` command. Potential savings: **~150-200ms**.

```lua
{ "folke/tokyonight.nvim", lazy = true, config = conf("tokyonight") },
-- Only your default (if any) needs lazy = false
```

**Consolidate further:** You rarely use all 10. Keep 2-3 favorites; uninstall the rest.

### 2. Abandoned plugins — replace or remove

| Plugin | Last commit | Status | Alternative |
|--------|-------------|--------|-------------|
| **vim-maximizer** | 2015 (!) | Abandoned 10+ years | Native `<C-w>\|` + `<C-w>_`, or `declancm/maximize.nvim` |
| **vim-signature** | 2018 | Abandoned 7+ years | `chentoast/marks.nvim` (modern, active) |
| **vim-niceblock** | 2018 | Abandoned | Native visual block (`<C-v>` + `I`/`A`) covers 90% |
| **popup.nvim** | 2021 | Zombie dep — **no plugin uses it in your config** | **Delete** |
| **winshift.nvim** | 2022 | Stale | `mrjones2014/smart-splits.nvim` (already installed!) |
| **feline.nvim** | 2023-09 | Maintenance mode | `lualine.nvim` or `rebelot/heirline.nvim` |
| **vim-abolish** | 2023-09 | Stale (but works) | Usable, but modern: `text-case.nvim` (already installed) |

**Savings:** Removing 5-6 of these = **~50-80ms** startup + cleaner surface area.

### 3. Functional overlap — duplicate plugins

| Overlap | Keep | Remove |
|---------|------|--------|
| `nvim-tmux-navigation` + `smart-splits.nvim` | smart-splits (handles tmux too) | nvim-tmux-navigation |
| `winshift.nvim` + `smart-splits.nvim` | smart-splits | winshift |
| `alpha-nvim` + `snacks.dashboard` | snacks.dashboard (already installed, disabled) | alpha-nvim |
| `nvim-notify` + `snacks.notifier` | snacks.notifier | nvim-notify |
| `tabular` + `mini.ai`/`vim.fmt` | mini.ai already handles alignment | tabular (if unused) |
| `Comment.nvim` | Neovim 0.10+ has native `gc`/`gcc` | **Comment.nvim entirely** |
| `vim-abolish` + `text-case.nvim` | text-case | vim-abolish |

Enabling snacks.dashboard + snacks.notifier and removing alpha + nvim-notify = ~30-50ms saved + 2 fewer plugins.

---

## 🟡 MEDIUM — Lazy Loading Opportunities

### 4. Plugins that should be lazy but aren't

| Plugin | Current | Should be |
|--------|---------|-----------|
| `alpha-nvim` | `event = "VimEnter"` | `event = "VimEnter"` is fine, but move to snacks.dashboard |
| `bufferline.nvim` | `event = "VimEnter"` | `event = "UIEnter"` or `event = "BufAdd"` |
| `feline.nvim` | `event = "VeryLazy"` | Good already — but replace plugin |
| `noice.nvim` | `event = "VeryLazy"` | Consider removing — heavy, duplicates snacks features |
| `modes.nvim` | `lazy_load` | `event = "ModeChanged"` |
| `nvim-spider` | `event = "VimEnter"` | `keys = { "w", "e", "b", "ge" }` — only load on first use |
| `nvim-web-devicons` | always loaded | `lazy = true` — loaded by plugins that need it |
| `todo-comments.nvim` | `lazy_load` | `event = "BufRead"` |
| `vim-matchup` | `event = "BufRead"` | Already good |
| `indent-blankline.nvim` | `lazy_load` | `event = "BufRead"` |
| `indent-o-matic` | `event = "VimEnter"` | `event = "BufRead"` |

### 5. `nvim-treesitter-compat.lua` costs ~34ms at startup
Your `after/plugin/nvim-treesitter-compat.lua` calls `require("nvim-treesitter.query")` eagerly to get `get_parser_from_markdown_info_string`. This forces nvim-treesitter to load.

**Fix:** Inline the simple `alias:lower():match("^%s*(%S+)")` logic instead of requiring the module. You already do this fallback — just always use it.

### 6. Colorscheme priority inverted
`snacks.nvim` has `priority = 1000` but no colorscheme does. This means snacks loads *before* colorschemes, so highlights aren't yet applied.

**Fix:** Give your default colorscheme `priority = 1000` and only that one needs `lazy = false`.

---

## 🟢 LOW — Minor Bloat / Cleanup

### 7. Plugins with questionable value
- **`firenvim`** — only used for browser textareas; unload on regular Neovim
- **`cellular-automaton.nvim`** — literally a joke plugin, just for `:CellularAutomaton make-it-rain`. Delete unless you genuinely use it
- **`leetcode.nvim`** — only useful if you actually grind leetcode; pulls in 5+ deps
- **`vim-markdown-toc`** — mkdnflow has TOC support now
- **`linediff.vim`** — diffview handles this too
- **`zenbones.nvim` with `lush.nvim`** — lush is pulled in as a hard dep just for this one colorscheme. Drop zenbones if not your main.

### 8. Dead config files
Check `lua/user/plugins/` for orphan configs with no matching plugin spec:
- `nvim-cmp.lua` already deleted in earlier session ✓
- `hardtime.lua` — plugin commented out but config exists
- `codeium.lua` — plugin commented out but config exists
- `dropbar.lua` — plugin commented out but config exists
- `copilot-cmp.lua` — plugin commented out but config exists
- `LuaSnip.lua` — blink.cmp uses friendly-snippets directly
- `ultisnips.lua` — using luasnip via blink, not ultisnips
- `snippet-converter.lua` — orphaned
- `neorg-telescope.lua`, `neorg.lua` — plugin commented out
- `obsidian.lua` — plugin commented out
- `vimwiki.lua` — plugin commented out
- `project.lua` — plugin not registered
- `vim-signature.lua` — about to be removed
- `vim-smartq.lua` — probably unused config
- `rest.lua`, `lens.lua`, `true-zen.lua`, `vim-illuminate.lua` — check if registered

**Potential cleanup:** ~10-15 orphaned config files. Delete them.

### 9. Deprecated configs detected

- `noice.nvim`: commented-out `lsp.signature` block already addressed
- `nvim-notify`: `top_down = false, stages = "static"` — works but snacks.notifier is better
- `vim-fugitive` custom fork (`sindrets/vim-fugitive`) — check if upstream has merged the feature you needed
- `TimUntersberger/neogit` — the repo moved to `NeogitOrg/neogit` years ago

### 10. Never-called functions in config
- `use_local()` helper in plugins/init.lua — defined but never used
- Dead vimscript in `core/` directory

---

## 🚀 Performance Improvements

### 11. Startup bottlenecks (from `--startuptime`)

| Item | Time | Fix |
|------|------|-----|
| `require('user.plugins')` | 400ms | Consolidate + lazy load aggressively |
| `vimrc` sourcing | 40ms | Migrate to Lua (load time faster) |
| `core/core.vim` | 30ms | Migrate to Lua or inline into init.lua |
| `nvim-treesitter-compat.lua` | 34ms | Remove `require('nvim-treesitter.query')` |
| `inits 1` | 40ms | Native Nvim — not controllable |

**Target achievable:** ~100-150ms startup (5-6x faster than current) with all fixes applied.

### 12. Enable lazy.nvim performance features

In `lua/user/plugins/lazy_nvim.lua`, the `performance.rtp.disabled_plugins` block is commented out. Uncomment it to disable ~15 built-in plugins you don't use (`netrw`, `gzip`, `tar`, etc.) — saves ~20-30ms.

---

## 📋 Action Plan (in order)

### Quick wins (1 hour, ~250ms saved)
1. Add `lazy = true` to 9 of 10 colorschemes
2. Delete `popup.nvim` (zombie dep)
3. Delete `vim-maximizer`, `vim-signature`, `vim-niceblock`, `winshift.nvim`
4. Delete `Comment.nvim` (native `gc`/`gcc` in 0.10+)
5. Delete orphaned config files in `lua/user/plugins/`
6. Uncomment `performance.rtp.disabled_plugins` in `lazy_nvim.lua`

### Medium (2-3 hours, ~100ms saved)
7. Replace `alpha-nvim` with snacks.dashboard (toggle `dashboard.enabled = true` in snacks.lua)
8. Replace `nvim-notify` with snacks.notifier
9. Replace `feline.nvim` with `lualine.nvim` or `heirline.nvim`
10. Remove `nvim-tmux-navigation` (smart-splits covers it)
11. Fix `nvim-treesitter-compat.lua` to not require nvim-treesitter at startup

### Larger changes (evaluate case-by-case)
12. Evaluate `noice.nvim` — do you actually need the cmdline rework? Performance cost is high
13. Consolidate notetaking: mkdnflow + markview + markdown-preview + vim-markdown-toc is a lot for one use case
14. Migrate `vimrc` and `core/*.vim` to Lua

---

## 📝 Summary Table

| Category | Count | Action |
|----------|-------|--------|
| 🔴 Delete abandoned | 5-7 | `vim-maximizer`, `vim-signature`, `vim-niceblock`, `popup.nvim`, `winshift.nvim`, `Comment.nvim`, possibly `feline.nvim` |
| 🔴 Delete redundant | 3-4 | `alpha-nvim`, `nvim-notify`, `nvim-tmux-navigation`, `vim-abolish` |
| 🟡 Add `lazy = true` | 9 | 9 colorschemes |
| 🟡 Fix lazy triggers | 5-7 | `nvim-spider`, `nvim-web-devicons`, `indent-blankline`, etc. |
| 🟢 Delete orphan configs | ~10 | `lua/user/plugins/*.lua` for uninstalled plugins |
| 🟢 Enable rtp disabled_plugins | 1 | Uncomment block in `lazy_nvim.lua` |

**Estimated result:** 110 plugins → ~75, startup 600ms → ~150ms.
