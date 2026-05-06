# Neovim Config Audit — 2026-05-06

## 📊 Stats

| Metric | Previous audit (2026-05-05) | Current | Benchmark |
|--------|-----------------------------|---------|-----------|
| Total plugins | 110 | **101** (-9) | Well-tuned: 30-60 |
| Idle startup | ~600ms | **~70ms** (-88%) | Goal: <100ms ✅ |
| File-open startup | (not measured) | ~470ms | Goal: <200ms |
| Eager-loaded (`lazy=false`, no lazy trigger) | 26 | **2** (-92%) | Goal: <5 ✅ |
| Abandoned plugins | 7 | 0 | ✅ |

**Eager-loaded plugins (the minimum):**
- `tokyonight.nvim` — active colorscheme (auto-lazy via `cs()` helper in plugins/init.lua)
- `snacks.nvim` — foundational UI modules (priority=1000, deliberately eager)

---

## ✅ Changes since previous audit

### Fixed
- [x] Colorscheme auto-lazy loading — `g:colorscheme` in vimrc, `cs()` helper handles lazy/priority
- [x] Centralized user settings in vimrc (`g:colorscheme`, `g:default_dark_colorscheme`, `g:default_light_colorscheme`)
- [x] Removed 9 plugins: `popup.nvim` (zombie dep), `vim-maximizer`, `vim-signature`, `vim-niceblock`, `winshift.nvim`, `Comment.nvim`, `nvim-tmux-navigation`, `leetcode.nvim`, `vim-markdown-toc`
- [x] Re-added 3 still-needed plugins with modern replacements:
  - `chentoast/marks.nvim` (replaces vim-signature — active, same default mappings)
  - `kana/vim-niceblock` (re-added; no modern equivalent for ragged visual-block)
  - `sindrets/winshift.nvim` (re-added; not actually abandoned, and `Config.common.utils` depends on it)
- [x] **Migrated feline.nvim → lualine.nvim** (Option A — simplified layout, `theme="auto"` follows colorscheme)
- [x] `Comment.nvim` removed — Neovim 0.10+ native `gc`/`gcc` takes over; `ts-comments.nvim` preserved for treesitter-aware injected languages
- [x] 6 lazy triggers tightened: `firenvim` → `cond=started_by_firenvim`, `vim-eunuch` → `cmd=[...]`, `twilight`/`transparent` → `cmd=[...]`, `smart-splits`/`focus` → `event=VeryLazy`
- [x] `nvim-treesitter` Nvim 0.13 compat — `set-lang-from-info-string!` directive patched inside the plugin's config hook (no more markdown fence crashes)
- [x] `vim-matchup` treesitter integration re-enabled (% across injected-language fences)
- [x] `nvim-treesitter-compat.lua` inlined (dropped `require('nvim-treesitter.query')` — saved ~30ms)
- [x] `nvim-web-devicons` → `lazy=true` (pulled in by plugins that declare the dep)
- [x] `modes.nvim` → `event=ModeChanged`
- [x] `bufferline.nvim` → `event=UIEnter`
- [x] `todo-comments`, `indent-blankline`, `indent-o-matic` → `event=BufReadPre`/`BufReadPost`
- [x] `nvim-spider` → `keys=` trigger (only on first motion keypress)
- [x] `nvim-notify` → `event=VeryLazy` (noice is its main consumer, loads at VeryLazy)
- [x] Deprecated Neovim APIs replaced: `vim.tbl_add_reverse_lookup` → manual pairs, `BufModifiedSet` → `OptionSet` w/ pattern="modified"
- [x] `blink.cmp` v2 build + `saghen/blink.lib` dependency added
- [x] `nvim-treesitter` pinned to archived `master` (commit cf12346) to avoid the broken `main` branch rewrite
- [x] ~23 orphan config files in `lua/user/plugins/` deleted
- [x] vim-abolish kept (for `:Subvert`); text-case.nvim kept for the rest
- [x] noice.nvim kept (user pref); alpha-nvim kept (custom banner/responsive layout)

### Not yet done
- [ ] Migrate `vimrc` + `core/*.vim` to Lua (~70ms in vimscript source time)
- [ ] Tame `require("user.lsp")` 67ms hotspot — eager mason/lspconfig init
- [ ] Investigate file-open startup (~470ms) — markdown FileType autocmd + mason-lspconfig + blink.cmp contributions

---

## 📋 Current action plan

### 🟢 Remaining low-hanging fruit (< 30 min each)

| # | Task | Est. saving |
|---|------|-------------|
| 1 | `alpha-nvim` migrate sections to snacks.dashboard (keep alpha's banner) | -1 plugin, ~10ms |
| 2 | `vim-abolish` — confirm `:Subvert` is the only thing used, check if text-case has added it | maybe -1 plugin |
| 3 | `firenvim.lua` config — audit in browser mode | correctness |

### 🟡 Medium effort (30-60 min)

| # | Task | Est. saving |
|---|------|-------------|
| 4 | Profile `require("user.lsp")` (67ms) — defer to `LspAttach` or `vim.schedule` better | -30-50ms startup |
| 5 | Investigate file-open slowdown — mason-lspconfig loading every server at BufReadPost? | -50-100ms |
| 6 | `nvim-web-devicons` — verify `config` wrapper still applies custom icons (since it's now `lazy=true`) | correctness |

### 🔴 Larger changes (2-4 hours, separate session)

| # | Task | Est. saving |
|---|------|-------------|
| 7 | Migrate `vimrc` + `core/*.vim` to Lua (`core.vim`, `general.vim`, `mappings.vim`, `terminal.vim`, `rtp.vim`, `utils.vim`) | -60-70ms |
| 8 | Consolidate notetaking: mkdnflow + markview + markdown-preview is a lot. Decide which to drop. | -1-2 plugins |
| 9 | Evaluate `cellular-automaton` + `linediff` (user flagged as keep, but revisit periodically) | -1-2 plugins |

---

## 🩺 Health checks that pass

| Check | Status |
|-------|--------|
| No startup errors | ✅ |
| Markdown fenced code blocks render without treesitter crashes | ✅ |
| LSP attaches correctly on opening buffers | ✅ |
| `gc`/`gcc` native commenting works | ✅ |
| `%` jumps across brackets in injected languages (matchup + treesitter) | ✅ |
| Colorscheme auto-switch (only active scheme loads eagerly) | ✅ |
| Plugin categories toggleable via vimrc (`g:lsp_enabled`, `g:treesitter_enabled`, `g:git_enabled`, `g:notetaking_enabled`) | ✅ |
| Low-performance mode (`g:low_performance_mode`) disables noice, notify, twilight, transparent, focus | ✅ |

---

## 📝 Summary Table

| Category | Delta since last audit | Current count |
|----------|----------------------|---------------|
| Plugins | -9 | 101 |
| Eager-loaded | -24 | 2 |
| Startup (idle) | -530ms | ~70ms |
| Orphan config files | -23 | 0 |

**Headline:** Config is now in the "healthy" band — idle startup under 100ms, eager plugins at the absolute minimum, no abandoned dependencies. The remaining wins are architectural (LSP lazy loading, vimscript → Lua migration) rather than plugin-level.

---

## Next audit reminder

Run `@audit-neovim` SOP periodically (monthly is reasonable) to re-measure. The SOP:
- Collects plugin count, startup time, eager loads, abandoned plugins (via git log dates)
- Detects functional overlaps
- Flags orphan config files
- Scans for new deprecated Nvim APIs
- Produces a fresh prioritized action plan
