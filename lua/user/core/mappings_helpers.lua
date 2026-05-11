-- Mapping helpers & side-effects formerly in mappings_vim.lua:
--   - Leaders + <Nop> prefix reservations
--   - Global helper functions (called by entries in mappings.lua)
--   - Autocmds that complement mappings (TabLeave lasttab, qf `dd`, etc.)
--   - :RemoveQFItem user command
--
-- Loaded from core.lua BEFORE load_mappings() runs so helpers and leaders
-- are available when mappings.lua registers entries.

local fn = vim.fn
local keymap = vim.keymap.set

-- ─── Leaders + Nop prefix reservations ───────────────────────────────────────

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Release keymap prefixes so they can be used freely by plugin mappings
keymap({ "n", "x" }, "<Space>", "<Nop>")
keymap({ "n", "x" }, ",", "<Nop>")
keymap({ "n", "x" }, ";", "<Nop>")

-- ─── Exported helpers (both as _G globals and vimscript wrappers) ────────────

-- AddSubtract: increment/decrement next searcheable number, repeatable via vim-repeat
local function add_subtract(char, back)
  local pattern = vim.o.nrformats:match("alpha") and "[[:alpha:][:digit:]]" or "[[:digit:]]"
  fn.search(pattern, "cw" .. back)
  vim.cmd("normal! " .. vim.v.count1 .. char)
  pcall(fn["repeat#set"], vim.api.nvim_replace_termcodes(
    ":<C-u>call AddSubtract('" .. char .. "', '" .. back .. "')<CR>", true, false, true))
end
_G.AddSubtract = add_subtract
vim.cmd([[
  function! AddSubtract(char, back) abort
    call v:lua.AddSubtract(a:char, a:back)
  endfunction
]])

-- ShiftCharAscii: shift ASCII code of char at cursor (normal mode)
local function shift_char_ascii(char, shift)
  local nr = fn.char2nr(char)
  vim.cmd("normal! r" .. fn.nr2char(nr + shift))
end
_G.ShiftCharAscii = shift_char_ascii

-- VShiftCharAscii: shift ASCII codes of visual selection
local function v_shift_char_ascii(shift)
  local start_pos, end_pos = fn.getpos("'<"), fn.getpos("'>")
  local line_start, col_start = start_pos[2], start_pos[3]
  local line_end, col_end = end_pos[2], end_pos[3]
  local lines = fn.getline(line_start, line_end)
  if #lines == 0 then return end
  lines[#lines] = lines[#lines]:sub(1, col_end)
  lines[1] = lines[1]:sub(col_start)
  local str = table.concat(lines, "\n")
  local chars = {}
  for i = 1, #str do
    table.insert(chars, fn.nr2char(fn.char2nr(str:sub(i, i)) + shift))
  end
  local clipboard = fn.getreg("+")
  fn.setreg("+", table.concat(chars))
  vim.cmd("normal! gvpgv")
  fn.setreg("+", clipboard)
end
_G.VShiftCharAscii = v_shift_char_ascii

-- LazyNorm: run a normal-mode command with 'lazyredraw' on
local function lazy_norm(cmd)
  local save = vim.o.lazyredraw
  vim.o.lazyredraw = true
  local ok, err = pcall(vim.cmd, "norm! " .. cmd)
  vim.o.lazyredraw = save
  if not ok then
    vim.api.nvim_echo({ { tostring(err), "ErrorMsg" } }, true, {})
  end
end
_G.LazyNorm = lazy_norm

-- Preserve: save search + cursor, run cmd, restore
local function preserve(cmd)
  local save_search = fn.getreg("/")
  local l, c = fn.line("."), fn.col(".")
  pcall(vim.cmd, cmd)
  fn.setreg("/", save_search)
  fn.cursor(l, c)
end
_G.Preserve = preserve
vim.cmd([[
  function! Preserve(command) abort
    call v:lua.Preserve(a:command)
  endfunction
]])

-- GetSelection: capture visual selection into @/ for search
local function get_selection(cmdtype)
  local temp = fn.getreg("s")
  vim.cmd('normal! gv"sy')
  local sel = fn.getreg("s")
  local pattern = fn.substitute(fn.escape(sel, "\\" .. cmdtype), "\n", "\\\\n", "g")
  fn.setreg("/", pattern)
  fn.setreg("s", temp)
end
_G.GetSelection = get_selection
vim.cmd([[
  function! GetSelection(cmdtype) abort
    call v:lua.GetSelection(a:cmdtype)
  endfunction
]])

-- VimgrepWrapper: grep across project files of same extension
local function vimgrep_wrapper(input, casing)
  casing = casing or ""
  local ext = fn.expand("%:e")
  local pattern = "/\\" .. casing .. input .. "/j"
  if ext ~= "" then
    vim.cmd("noautocmd vimgrep " .. pattern .. " **/*." .. ext)
  else
    vim.cmd("noautocmd vimgrep " .. pattern .. " **/*")
  end
  vim.cmd("cw")
end
_G.VimgrepWrapper = vimgrep_wrapper
vim.cmd([[
  function! VimgrepWrapper(input, ...) abort
    call v:lua.VimgrepWrapper(a:input, get(a:000, 0, ''))
  endfunction
]])

-- AutoIndentPaste: set buffer-local p/P to paste+indent for non-text filetypes
local function auto_indent_paste()
  local ft = vim.bo.filetype
  if ft == "markdown" or ft == "text" or ft == "snippets" or ft == "tex" then return end
  keymap("n", "p", "p=`]", { buffer = 0 })
  keymap("n", "P", "P=`]", { buffer = 0 })
end
_G.AutoIndentPaste = auto_indent_paste
vim.cmd([[
  function! AutoIndentPaste() abort
    call v:lua.AutoIndentPaste()
  endfunction
]])

-- LocationlistToggle / QuickfixToggle
local function locationlist_toggle()
  for i = 1, fn.winnr("$") do
    if fn.getbufvar(fn.winbufnr(i), "&buftype") == "locationlist" then
      vim.cmd("lclose"); return
    end
  end
  vim.cmd("lopen")
end
_G.LocationlistToggle = locationlist_toggle
vim.cmd([[
  function! LocationlistToggle() abort
    call v:lua.LocationlistToggle()
  endfunction
]])

local function quickfix_toggle()
  for i = 1, fn.winnr("$") do
    if fn.getbufvar(fn.winbufnr(i), "&buftype") == "quickfix" then
      vim.cmd("cclose"); return
    end
  end
  vim.cmd("copen")
end
_G.QuickfixToggle = quickfix_toggle
vim.cmd([[
  function! QuickfixToggle() abort
    call v:lua.QuickfixToggle()
  endfunction
]])

-- RemoveQFItem: dd in quickfix list removes current item
local function remove_qf_item()
  local idx = fn.line(".") - 1
  local qflist = fn.getqflist()
  table.remove(qflist, idx + 1)
  fn.setqflist(qflist, "r")
  vim.cmd((idx + 1) .. "cfirst")
  vim.cmd("copen")
end
_G.RemoveQFItem = remove_qf_item
vim.api.nvim_create_user_command("RemoveQFItem", remove_qf_item, {})

-- NextClosedFold / NextOpenFold
local function next_closed_fold(direction)
  local cmd = "norm!z" .. direction
  local view = fn.winsaveview()
  local l0, l, open = 0, view.lnum, true
  while l ~= l0 and open do
    vim.cmd(cmd)
    l0, l = l, fn.line(".")
    open = fn.foldclosed(l) < 0
  end
  if open then fn.winrestview(view) end
end
_G.NextClosedFold = next_closed_fold
vim.cmd([[
  function! NextClosedFold(direction) abort
    call v:lua.NextClosedFold(a:direction)
  endfunction
]])

local function next_open_fold(direction)
  if direction == "j" then
    vim.cmd("normal zj")
    local start = fn.line(".")
    while fn.foldclosed(start) ~= -1 do start = start + 1 end
    fn.cursor(start, 0)
  else
    vim.cmd("normal zk")
    local start = fn.line(".")
    while fn.foldclosed(start) ~= -1 do start = start - 1 end
    fn.cursor(start, 0)
  end
end
_G.NextOpenFold = next_open_fold
vim.cmd([[
  function! NextOpenFold(direction) abort
    call v:lua.NextOpenFold(a:direction)
  endfunction
]])

-- SubstituteOddCharacters: replace smart quotes, em-dashes, etc. in last visual
local function substitute_odd_characters()
  local subs = {
    [[gv:s/“/"/ge]], [[gv:s/”/"/ge]], [[gv:s/’/'/ge]],
    [[gv:s/—/--/ge]], [[gv:s/…/.../ge]], [[gv:s/•/-/ge]],
    [[gv:s/ ,/,/ge]], [[gv:s/  /\r\r/ge]], [[gv:s/   / /ge]],
    [[gv:s/ \././ge]], [[gv:s/​//ge]],
    [[gv:s/\(\\\)\@<!\((\)\?\$\([0-9,.]\+\)\(\s\|\n\|)\)/\2\\$\3\4/ge]],
  }
  for _, s in ipairs(subs) do
    pcall(vim.cmd, "silent norm! " .. s)
  end
  vim.cmd("redraw")
end
_G.SubstituteOddCharacters = substitute_odd_characters
vim.cmd([[
  function! SubstituteOddCharacters() abort
    call v:lua.SubstituteOddCharacters()
  endfunction
]])

-- SmartPaste: paste + reindent + whitespace clean + odd-char substitute
local function smart_paste()
  vim.cmd([[norm! ]] .. vim.api.nvim_replace_termcodes("<M-p>", true, false, true) .. [[`[v`]=]])
  pcall(vim.cmd, "norm! gv:WhitespaceErase\r")
  substitute_odd_characters()
  vim.cmd("norm! gv=gvgw")
  vim.cmd("norm! 0`>")
end
_G.SmartPaste = smart_paste
vim.cmd([[
  function! SmartPaste() abort
    call v:lua.SmartPaste()
  endfunction
]])

-- EliteModeToggle: disable LSP + Copilot for distraction-free mode
local function elite_mode_toggle()
  if vim.g.elite_mode then
    pcall(vim.cmd, "LspStart")
    pcall(vim.cmd, "Copilot enable")
    vim.api.nvim_echo({ { "Elite mode off" } }, true, {})
    vim.g.elite_mode = false
  else
    pcall(vim.cmd, "LspStop")
    pcall(vim.cmd, "Copilot disable")
    vim.api.nvim_echo({ { "Elite mode on" } }, true, {})
    vim.g.elite_mode = true
  end
end
_G.EliteModeToggle = elite_mode_toggle
vim.cmd([[
  function! EliteModeToggle() abort
    call v:lua.EliteModeToggle()
  endfunction
]])

-- ─── Toggle helpers (for SettingsToggleMappings) ─────────────────────────────

local Toggles = {}

function Toggles.conceal()
  if vim.o.conceallevel ~= 0 then
    vim.o.conceallevel = 0
    vim.api.nvim_echo({ { "Conceallevel 0" } }, true, {})
  else
    vim.o.conceallevel = 3
    vim.api.nvim_echo({ { "Conceallevel 3" } }, true, {})
  end
end

function Toggles.foldcolumn1()
  if vim.o.foldcolumn == "0" then
    vim.o.foldcolumn = "1"
    vim.api.nvim_echo({ { "Foldcolumn 1" } }, true, {})
  else
    vim.o.foldcolumn = "0"
    vim.api.nvim_echo({ { "Foldcolumn 0" } }, true, {})
  end
end

function Toggles.gutter()
  if vim.o.signcolumn == "yes" then
    vim.o.signcolumn = "no"
    vim.api.nvim_echo({ { "Sign gutter deactivated" } }, true, {})
  else
    vim.o.signcolumn = "yes"
    vim.api.nvim_echo({ { "Sign gutter activated" } }, true, {})
  end
end

function Toggles.virtualedit()
  if vim.o.virtualedit == "" then
    vim.o.virtualedit = "all"
    vim.api.nvim_echo({ { "Virtualedit activated" } }, true, {})
  else
    vim.o.virtualedit = ""
    vim.api.nvim_echo({ { "Virtualedit deactivated" } }, true, {})
  end
end

function Toggles.text_wrapping()
  if not vim.o.formatoptions:find("t", 1, true) then
    vim.opt.formatoptions:append("t")
    vim.api.nvim_echo({ { "Text wrapping activated" } }, true, {})
  else
    vim.opt.formatoptions:remove("t")
    vim.api.nvim_echo({ { "Text wrapping deactivated" } }, true, {})
  end
end

function Toggles.background()
  local scheme = vim.g.colors_name
  if not scheme then
    vim.api.nvim_echo({ { "No colorscheme set" } }, true, {}); return
  end
  if scheme:match("dark") or scheme:match("light") then
    local new = scheme:match("dark") and scheme:gsub("dark", "light") or scheme:gsub("light", "dark")
    vim.cmd("colorscheme " .. new)
  else
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
    if not vim.g.colors_name then
      vim.cmd("colorscheme " .. scheme)
      vim.api.nvim_echo({ { "The colorscheme `" .. scheme .. "` doesn't have background variants!" } }, true, {})
    else
      vim.api.nvim_echo({ { "Set colorscheme to " .. vim.o.background .. " mode" } }, true, {})
    end
  end
end

function Toggles.format_on_save()
  vim.g.enable_format_on_save = not vim.g.enable_format_on_save
  local msg = vim.g.enable_format_on_save and "Format on save activated" or "Format on save deactivated"
  vim.api.nvim_echo({ { msg } }, true, {})
end

function Toggles.low_performance_mode()
  vim.g.low_performance_mode = not vim.g.low_performance_mode
  local msg = vim.g.low_performance_mode
    and "Low performance mode ON. Restart nvim to take effect"
    or "Low performance mode OFF. Restart nvim to take effect"
  vim.api.nvim_echo({ { msg } }, true, {})
  if _G.CacheToDataDir then
    _G.CacheToDataDir("low_performance_mode", vim.g.low_performance_mode)
  end
end

function Toggles.smart_wrap()
  local cc = vim.wo.colorcolumn == "" and tostring(vim.bo.textwidth) or ""
  vim.cmd("setlocal wrap! breakindent! colorcolumn=" .. cc)
end

_G.ConfigToggles = Toggles

-- ─── Autocmds that complement mappings ──────────────────────────────────────

-- Track last-active tab so <LocalLeader>tl can jump to it
vim.api.nvim_create_autocmd("TabLeave", {
  group = vim.api.nvim_create_augroup("user_lasttab", { clear = true }),
  callback = function() vim.g.lasttab = fn.tabpagenr() end,
})

-- Auto-indent paste hook — refreshed on buffer write
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("user_auto_indent_paste", { clear = true }),
  callback = function() auto_indent_paste() end,
})

-- Quickfix window: `dd` removes current item
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_qf_dd", { clear = true }),
  pattern = "qf",
  callback = function()
    keymap("n", "dd", ":RemoveQFItem<CR>", { buffer = true })
  end,
})

-- Diff mode help messages (shown once per diff-mode activation)
local function print_merge_diff_mappings()
  if vim.g.custom_diff_enable == 1 then return end

  local function diff_expr(c) return function() return vim.wo.diff and c or "" end end
  keymap("n", "db", diff_expr(":diffget BASE<CR>"), { expr = true })
  keymap("n", "dl", diff_expr(":diffget LOCAL<CR>"), { expr = true })
  keymap("n", "dr", diff_expr(":diffget REMOTE<CR>"), { expr = true })
  keymap("n", "cq", diff_expr(":cquit<CR>"), { expr = true })

  for _, m in ipairs({
    " ",
    "dp :diffput",
    "do :diffget",
    "db :diffget BASE (git mergetool only)",
    "dl :diffget LOCAL (git mergetool only)",
    "dr :diffget REMOTE (git mergetool only)",
    "cq :cquit",
    "]c or ]x Next conflict",
    "[c or [x Previous conflict",
  }) do vim.api.nvim_echo({ { m } }, true, {}) end

  if vim.g.custom_diff_enable == nil then
    vim.api.nvim_echo(
      { { "To view these again, type :messages or :lua _G.PrintMergeDiffMappings()", "WildMenu" } },
      true, {})
  end
  vim.g.custom_diff_enable = 1
end
_G.PrintMergeDiffMappings = print_merge_diff_mappings

vim.api.nvim_create_autocmd("OptionSet", {
  group = vim.api.nvim_create_augroup("user_diffmode", { clear = true }),
  pattern = "diff",
  callback = function()
    if vim.v.option_old == 0 and vim.v.option_new ~= 0 then
      print_merge_diff_mappings()
    else
      vim.g.custom_diff_enable = 0
    end
  end,
})

-- Ensure wildcharm is set for the `feedkeys(':... <Tab>')` pattern used by diff
-- and session mappings.
if vim.o.wildcharm == 0 then vim.o.wildcharm = vim.fn.char2nr("\t") end
