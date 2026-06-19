-- Port of autocommands.vim

local api = vim.api
local aucmd = api.nvim_create_autocmd
local group = api.nvim_create_augroup("NvimConfig", { clear = true })

-- ─── Temp file handling (swap/undo/shada disable) ─────────────────────────────
-- NOTE: /tmp/* swap/undo/backup disable is handled in core/general.lua's
-- `user_secure` augroup — intentionally not duplicated here.

-- Disable viminfo/shada in temp dirs
aucmd({ "BufNewFile", "BufReadPre" }, {
  group = group,
  pattern = { "/tmp/*", "$TMPDIR/*", "$TMP/*", "$TEMP/*", "*/shm/*", "/private/var/*", ".vault.vim" },
  callback = function()
    vim.opt_local.shada = ""
  end,
})

-- ─── Swap / File handling ─────────────────────────────────────────────────────

-- Automatically set read-only for files being edited elsewhere
aucmd("SwapExists", {
  group = group,
  nested = true,
  callback = function() vim.v.swapchoice = "o" end,
})

-- Disable automatic comment continuation on newline
aucmd("FileType", {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Force write shada on leaving nvim
aucmd("VimLeave", {
  group = group,
  command = "wshada!",
})

-- Nuke netrw FileExplorer autocmds
aucmd("VimEnter", {
  group = group,
  callback = function()
    pcall(api.nvim_del_augroup_by_name, "FileExplorer")
  end,
})

-- Auto-cd to first argv if it's a directory or oil:// URL
aucmd("VimEnter", {
  group = group,
  callback = function()
    local arg = vim.fn.argv(0)
    if arg == "" or type(arg) ~= "string" then return end
    if vim.fn.isdirectory(arg) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(arg))
    elseif arg:match("^oil://") then
      vim.cmd("cd " .. vim.fn.fnameescape(arg:sub(7)))
    end
  end,
})

-- Project config + session sourcing
aucmd("VimEnter", {
  group = group,
  callback = function()
    require("user.au").source_project_config()
    require("user.au").source_project_session()
  end,
})

-- Restore cursor position on file open (except commit/git buffers)
aucmd("BufReadPost", {
  group = group,
  callback = function(ctx)
    local ft = vim.bo[ctx.buf].filetype
    if ft:match("commit") or ft:match("git") or ft:match("fugitive") then return end
    -- Skip fugitive:// and other special buffers
    local name = vim.api.nvim_buf_get_name(ctx.buf)
    if name:match("^fugitive://") or vim.bo[ctx.buf].buftype ~= "" then return end
    -- Defer to avoid E1312 inside reentrant autocmd contexts (e.g. fugitive reload)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(ctx.buf) then return end
      local last_line = vim.fn.line([['"]])
      if last_line >= 1 and last_line <= vim.fn.line("$") then
        pcall(vim.cmd, [[normal! g`"zz]])
      end
    end)
  end,
})

-- Highlight yanks (vim.hl preferred in 0.11+, fall back to vim.highlight)
aucmd("TextYankPost", {
  group = group,
  callback = function()
    pcall((vim.hl or vim.highlight).on_yank, {
      higroup = "Visual", timeout = 300, on_visual = true,
    })
  end,
})

-- Quickfix window settings
aucmd("BufWinEnter", {
  group = group,
  pattern = "quickfix",
  callback = function()
    vim.opt_local.buflisted = false
    vim.opt_local.wrap = false
    vim.opt_local.colorcolumn = ""
  end,
})

-- Disable modelines after the first time it's processed
aucmd("BufWinEnter", {
  group = group,
  callback = function() vim.opt_local.modeline = false end,
})

-- ─── Terminal ────────────────────────────────────────────────────────────────

aucmd("TermOpen", {
  group = group,
  callback = function() vim.b.term_start = (vim.uv or vim.loop).hrtime() end,
})

-- Auto-close interactive term buffers if exit is 0 and lifetime > 2s
aucmd("TermClose", {
  group = group,
  nested = true,
  callback = function(ctx)
    if vim.v.event.status ~= 0 then return end
    if vim.b[ctx.buf].term_keep then return end
    local start = vim.b[ctx.buf].term_start
    if not start then return end
    local lifetime_ms = ((vim.uv or vim.loop).hrtime() - start) / 1e6
    if lifetime_ms > 2000 then
      pcall(api.nvim_buf_delete, ctx.buf, { force = true })
    end
  end,
})

-- Auto-insert in terminal buffers when at end-of-buffer
aucmd({ "TermOpen", "BufEnter" }, {
  group = group,
  callback = function()
    local term_buf = (Config.state.term and Config.state.term.actual_curbuf) or 0
    if vim.bo[term_buf].buftype == "terminal" and vim.fn.line("w$") == vim.fn.line("$") then
      vim.cmd("startinsert")
    end
  end,
})

-- Fugitive blame — no listchars
aucmd({ "BufWinEnter", "FileType" }, {
  group = group,
  pattern = "fugitiveblame",
  callback = function() vim.opt_local.list = false end,
})

-- ─── Visual mode 'onemore' ───────────────────────────────────────────────────

aucmd("ModeChanged", {
  group = group,
  pattern = "*:[v]*",
  callback = function() vim.opt_local.virtualedit:append("onemore") end,
})

aucmd("ModeChanged", {
  group = group,
  pattern = "[v]*:*",
  callback = function() vim.opt_local.virtualedit = nil end,
})

-- ─── File reload / change detection ──────────────────────────────────────────

aucmd({ "BufEnter", "CursorHold" }, {
  group = group,
  callback = function() pcall(vim.cmd, "checktime %") end,
})

-- Open file location `foo/bar/baz:128:17`
aucmd("BufReadCmd", {
  group = group,
  pattern = "*:[0-9]*",
  callback = function()
    require("user.au").open_file_location(vim.fn.expand("<afile>"))
  end,
})

aucmd("FileChangedShellPost", {
  group = group,
  callback = function()
    Config.common.notify.config.info("File changed. Autoreloaded " .. vim.fn.expand("%"))
  end,
})

-- ─── Diff / compare_mode ─────────────────────────────────────────────────────

aucmd("BufWinLeave", {
  group = group,
  callback = function()
    if vim.t.compare_mode and vim.t.compare_mode ~= 0 then
      vim.cmd("diffoff")
    end
  end,
})

aucmd("BufEnter", {
  group = group,
  callback = function()
    if not (vim.t.compare_mode and vim.t.compare_mode ~= 0) then return end
    if vim.bo.buftype == "" then
      vim.opt_local.diff = true
      vim.opt_local.cursorbind = true
      vim.opt_local.scrollbind = true
      vim.opt_local.foldmethod = "diff"
      vim.opt_local.foldlevel = 0
    else
      vim.opt_local.diff = false
      vim.opt_local.cursorbind = false
      vim.opt_local.scrollbind = false
    end
  end,
})

-- ─── Cmdline window ──────────────────────────────────────────────────────────

aucmd("CmdwinEnter", {
  group = group,
  callback = function()
    vim.opt_local.filetype = "vim"
    -- Execute command from cmdline window while keeping it open
    vim.keymap.set("n", "<C-x>", "<CR>q:", { buffer = true })
  end,
})

-- ─── Filetype overrides ──────────────────────────────────────────────────────
-- NOTE: GLSL extension mapping (.vs/.fs → glsl) is handled in core/general.lua
-- via vim.filetype.add — intentionally not duplicated here.

-- ─── LSP: suppress FileType cascades on big files ────────────────────────────

local function buf_is_big(bufnr)
  local kb = Config.common.utils.buf_get_size(bufnr)
  return kb > 320
end

aucmd("LspAttach", {
  group = group,
  callback = function(ctx)
    if buf_is_big(ctx.buf) then
      vim.o.eventignore = "FileType"
      vim.schedule(function() vim.o.eventignore = "" end)
    end
  end,
})

aucmd("BufRead", {
  group = group,
  callback = function(ctx)
    if not buf_is_big(ctx.buf) then return end
    local notify = Config.common.notify
    local ts_context = prequire("treesitter-context")
    local todo_comments = prequire("todo-comments")
    local rainbow_delimiters = prequire("rainbow_delimiters")
    local smooth_cursor_utils = prequire("smoothcursor.utils")

    if ts_context then ts_context.disable() end
    if todo_comments then todo_comments.disable() end
    if rainbow_delimiters then rainbow_delimiters.disable() end
    if smooth_cursor_utils then smooth_cursor_utils.smoothcursor_stop() end

    notify.config.info("Big file detected: Disabled treesitter-context, todo-comments, illuminate, and rainbow-delimiters.")
  end,
})

-- ─── Auto-nohlsearch (vim-cool Lua adaptation) ───────────────────────────────
-- Ref: https://www.reddit.com/r/neovim/comments/1ct2w2h/lua_adaptation_of_vimcool_auto_nohlsearch

local hl_group = api.nvim_create_augroup("ibhagwan/ToggleSearchHL", { clear = true })

aucmd("InsertEnter", {
  group = hl_group,
  callback = function()
    vim.schedule(function() vim.cmd("nohlsearch") end)
  end,
})

aucmd("CursorMoved", {
  group = hl_group,
  callback = function()
    local view, rpos = vim.fn.winsaveview(), vim.fn.getpos(".")
    vim.cmd(string.format(
      "silent! keepjumps go%s",
      (vim.fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))
    ))
    local ok = pcall(vim.cmd, "silent! keepjumps norm! n")
    local insearch = ok and (function()
      local npos = vim.fn.getpos(".")
      return npos[2] == rpos[2] and npos[3] == rpos[3]
    end)()
    vim.fn.winrestview(view)
    if not insearch then
      vim.schedule(function() vim.cmd("nohlsearch") end)
    end
  end,
})

-- ─── nvim-ufo: attach + persist fold state across sessions ──────────────────
-- Strategy:
--   1. BufWinLeave/BufWritePost: :mkview saves fold state (viewoptions
--      already includes 'folds' in core/general.lua)
--   2. BufWinEnter: :silent! loadview restores fold state if available
--   3. Fallback (no view file): all folds open via foldlevelstart=99
--
-- We DO NOT call foldclose! or ufo.closeAllFolds anywhere — that was the
-- old behavior from issue #146 which forced everything closed on open.
-- We only need to ensure ufo is attached so its fold provider works for
-- the manual zM/zR keymaps.

local ufo_group = api.nvim_create_augroup("kevinhwang91/nvim-ufo", { clear = true })

-- Skip view persistence + ufo attach for special buffers
local function should_skip(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return true end
  if name:match("^fugitive://") or name:match("^oil://") then return true end
  if vim.bo[buf].buftype ~= "" then return true end
  if vim.bo[buf].filetype == "" then return true end
  return false
end

-- Attach ufo on BufRead so fold provider is available for zM/zR
aucmd("BufRead", {
  group = ufo_group,
  callback = function(ctx)
    if should_skip(ctx.buf) then return end
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(ctx.buf) then return end
      local ufo = prequire("ufo")
      if not ufo then return end
      vim.wait(100, function() ufo.attach(ctx.buf) end)
    end)
  end,
})

-- Persist fold state on save / window leave
aucmd({ "BufWinLeave", "BufWritePost" }, {
  group = ufo_group,
  callback = function(ctx)
    if should_skip(ctx.buf) then return end
    pcall(vim.cmd, "silent! mkview")
  end,
})

-- Restore fold state when entering a window
aucmd("BufWinEnter", {
  group = ufo_group,
  callback = function(ctx)
    if should_skip(ctx.buf) then return end
    pcall(vim.cmd, "silent! loadview")
  end,
})
