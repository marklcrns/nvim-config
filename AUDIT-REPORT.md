# Neovim Config Audit — 2026-05-08

> 🎉 **Milestone:** This config is now **100% Lua**. Zero `.vim` files remain.

## 📊 Stats

| Metric | Previous audit (2026-05-06) | Current (2026-05-08) | Benchmark |
|--------|-----------------------------|----------------------|-----------|
| Total plugins | 101 | **101** | Well-tuned: 30-60 |
| **Idle startup** | ~70ms | **~52ms** (-26%) | Goal: <100ms ✅ |
| Eager-loaded | 2 | **2** | Goal: <5 ✅ |
| Abandoned plugins | 0 | 0 | ✅ |
| **`.vim` files** | ~50 | **0** 🎉 | Fully Lua |
| **Lua files** | ~80 | **144** | |

**Eager-loaded plugins (the minimum):**
- `tokyonight.nvim` — active colorscheme (auto-lazy via `cs()` helper in plugins/init.lua)
- `snacks.nvim` — foundational UI modules (priority=1000, deliberately eager)

---

## 🎯 This session's achievement: **Full vimscript → Lua migration**

18 commits, 3,000+ lines of vimscript converted to ~2,500 lines of idiomatic Lua.

### Core config

| File | Before | After |
|------|--------|-------|
| `core/core.vim` (80 lines) | vimscript | `lua/user/core/core.lua` (45 lines) |
| `core/general.vim` (380 lines) | vimscript | `lua/user/core/general.lua` (310 lines) |
| `core/rtp.vim` (29 lines) | vimscript | `lua/user/core/rtp.lua` (27 lines) |
| `core/utils.vim` (43 lines) | vimscript | merged into `lua/user/core/utils.lua` |
| `core/mappings.vim` (1,064 lines) | vimscript | `lua/user/core/mappings_vim.lua` (1,099 lines, 4 phases) |
| `core/terminal.vim` (133 lines) | vimscript | **deleted** (vim-only dead code) |
| `autocommands.vim` (227 lines) | vimscript | `lua/user/autocommands.lua` (335 lines) |
| `autoload/utils.vim` (147 lines) | vimscript | **deleted** (CoC-era dead code, `CustomBufferWrite` ported to `core.lua`) |

### Plugin scripts

| File | Before | After |
|------|--------|-------|
| `plugin/sessions.vim` (158 lines) | vimscript | consolidated into `lua/user/plugin_scripts.lua` |
| `plugin/whitespace.vim` (94 lines) | vimscript | consolidated into `lua/user/plugin_scripts.lua` |
| `plugin/grep-operator.vim` (33 lines) | vimscript | consolidated into `lua/user/plugin_scripts.lua` |
| `plugin/jumpfile.vim` (31 lines) | vimscript | consolidated into `lua/user/plugin_scripts.lua` |
| `plugin/quickfixopenall.vim` (29 lines) | vimscript | consolidated into `lua/user/plugin_scripts.lua` |
| `plugin/filesystem.vim` (25 lines) | vimscript | consolidated into `lua/user/plugin_scripts.lua` |
| `ginit.vim` (13 lines) | vimscript | merged into `general.lua` Neovide block |

### Filetype / syntax overrides

| Count | Before | After |
|-------|--------|-------|
| 24 `after/ftplugin/*.vim` (137 lines) | vimscript | 24 `.lua` equivalents |
| 7 `after/syntax/*.vim` (147 lines) | vimscript | 7 `.lua` equivalents |
| 3 `syntax/*.vim` (281 lines) | vimscript | `java.lua`, `NeogitStatus.lua` (haxe deleted — treesitter handles it) |

---

## ✅ Changes since previous audit

### New in this session

- [x] **100% Lua config** — all vimscript ported, deleted, or moved into Lua equivalents
- [x] `CustomBufferWrite` ported from `autoload/utils.vim` → `core.lua` (autoload auto-source was broken by migration)
- [x] `OSC 52 clipboard` provider for SSH sessions (kitty/iTerm2/WezTerm/tmux passthrough)
  - Cached copy/paste to prevent "Waiting for OSC 52 response" hang
  - `setreg("+", val)` now persists across reads
- [x] `vim.cmd.echo()` instead of `print()` in file-yank mappings — prevents redraw racing with OSC 52 emission
- [x] Fixed `nvim-treesitter-textobjects` breaking change: `repeatable_move` module renamed, `make_repeatable_move_pair` removed (compat shim added)
- [x] Removed yarn + pandoc from `install.sh` and README (stale from markdown-preview + vimwiki removal)
- [x] Which-key visual-mode group dedup (merged into normal-mode entries via `mode=`)

### Functional improvements carried from prior sessions
- Colorscheme auto-lazy loading (`g:colorscheme` in vimrc is single source of truth)
- 101 plugins, 2 eager-loaded
- All 5 plugin category switches working (`g:lsp_enabled`, `g:treesitter_enabled`, `g:git_enabled`, `g:notetaking_enabled`, `g:low_performance_mode`)
- `nvim-treesitter` Nvim 0.13 compat
- Feline → lualine migration complete

---

## 📋 Remaining backlog

### 🟢 Quick wins (< 30 min each)

| # | Task | Est. saving |
|---|------|-------------|
| 1 | `vim-abolish` — confirm `:Subvert` is only used feature, check if text-case.nvim added equivalent | maybe -1 plugin |
| 2 | `alpha-nvim` migrate sections to snacks.dashboard (keep banner) | -1 plugin, ~10ms |
| 3 | Rebind `;;` (Snacks picker resume) to avoid `;` treesitter-motion timeout | UX only |

### 🟡 Medium effort (30-60 min)

| # | Task | Est. saving |
|---|------|-------------|
| 4 | Tame `require("user.lsp")` hotspot — already deferred typescript-tools, mason-lspconfig (~22ms) remains hard to defer further without breaking autoregister | -20-30ms |
| 5 | Investigate file-open slowdown — mason-lspconfig loading every server at BufReadPost? | -50-100ms |

### 🔴 Larger (separate session)

| # | Task | Est. saving |
|---|------|-------------|
| 6 | Consolidate notetaking stack (now just markview after mkdnflow/markdown-preview/vimwiki removal — re-audit if anything else is now deadweight) | — |
| 7 | Revisit user-flagged "keep" plugins periodically (cellular-automaton, linediff) | -1-2 plugins |

---

## 🩺 Health checks

| Check | Status |
|-------|--------|
| No startup errors | ✅ |
| 100% Lua (zero `.vim` files) | ✅ |
| Markdown fenced code blocks render without treesitter crashes | ✅ |
| LSP attaches correctly on opening buffers | ✅ |
| OSC 52 clipboard copy works over SSH | ✅ |
| `gc`/`gcc` native commenting works | ✅ |
| `%` jumps across brackets in injected languages | ✅ |
| Colorscheme auto-switch | ✅ |
| All 279+ mappings migrated and functionally verified | ✅ |
| All 45 vimscript helper functions ported and callable | ✅ |
| All autocmd groups preserved (NvimConfig, plugin_*, user_*) | ✅ |

---

## 📝 Summary

| Metric | Start of 2026-05 | End of 2026-05-08 |
|--------|-------------------|--------------------|
| Plugins | 110 | 101 |
| Idle startup | ~600ms | **~52ms** (-91%) |
| Eager-loaded plugins | 26 | 2 |
| Orphan config files | 23 | 0 |
| Vimscript files | ~50 | **0** |
| Config language | Mixed | **100% Lua** |

**Headline:** This month the config went from a crashing, 600ms-startup, half-vimscript state to a stable, 52ms-startup, pure-Lua configuration with 91% faster startup, no abandoned dependencies, and every line of code readable in a single language.

---

## Next audit reminder

Run `@audit-neovim` SOP periodically (monthly) to re-measure. The SOP:
- Collects plugin count, startup time, eager loads, abandoned plugins
- Detects functional overlaps
- Flags orphan config files
- Scans for deprecated Nvim APIs
- Produces a fresh prioritized action plan
