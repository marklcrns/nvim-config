-- Port of plugin/*.vim (6 files → 1 consolidated module)
--
-- Sections:
--   1. filesystem       — auto-mkdir parent dir on BufWritePre
--   2. whitespace       — highlight + commands for trailing whitespace
--   3. grep-operator    — <leader>G operator for recursive grep on selection
--   4. jumpfile         — JumpBuffer() for jumplist buffer-level navigation
--   5. quickfixopenall  — :QuickFixOpenAll command
--   6. sessions         — SeshSave/Load/Delete/List/Close/Detach commands

local api = vim.api
local fn = vim.fn
local aucmd = api.nvim_create_autocmd
local usercmd = api.nvim_create_user_command

-- ═══════════════════════════════════════════════════════════════════════════
-- 1. filesystem — auto-mkdir parent dir on BufWritePre
-- ═══════════════════════════════════════════════════════════════════════════

aucmd("BufWritePre", {
  group = api.nvim_create_augroup("plugin_filesystem", { clear = true }),
  callback = function(ctx)
    local dir = fn.expand("<afile>:p:h")
    if fn.isdirectory(dir) == 1 or vim.bo[ctx.buf].buftype ~= "" then return end
    -- cmdbang forces silent create; otherwise prompt
    local force = vim.v.cmdbang and vim.v.cmdbang ~= 0
    if force or fn.input(
      string.format('"%s" directory does not exist. Create? [y/N] ', dir)
    ):match("^[Yy]") then
      fn.mkdir(dir, "p")
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════════
-- 2. whitespace — highlight + commands
-- ═══════════════════════════════════════════════════════════════════════════

local ws_chars = vim.g.whitespace_characters or [[\s]]
local ws_pattern = vim.g.whitespace_pattern or (ws_chars .. [[\+$]])
local normal_pattern = vim.g.whitespace_pattern_normal or (ws_pattern .. [[\| \+\ze\t]])
local insert_pattern = vim.g.whitespace_pattern_insert or (ws_chars .. [[\+\%#\@<!$]])
local blacklist = vim.g.whitespace_filetype_blacklist or {
  "diff", "git", "gitcommit", "help", "qf", "denite", "defx", "",
}

local function is_blacklisted()
  local bt = vim.bo.buftype
  if bt:match("nofile") or bt == "help" then return true end
  return vim.tbl_contains(blacklist, vim.bo.filetype)
end

local function toggle_whitespace(mode)
  if is_blacklisted() then return end

  local w = api.nvim_get_current_win()
  local match_id = vim.w.whitespace_match_id

  if mode == "" then
    if match_id then
      pcall(fn.matchdelete, match_id)
      vim.w.whitespace_match_id = nil
    end
    return
  end

  local pattern = mode == "i" and insert_pattern or normal_pattern
  if match_id then
    pcall(fn.matchdelete, match_id)
    fn.matchadd("ExtraWhitespace", pattern, 10, match_id)
  else
    vim.cmd("highlight! link ExtraWhitespace SpellBad")
    vim.w.whitespace_match_id = fn.matchadd("ExtraWhitespace", pattern)
  end
end

aucmd("InsertEnter", {
  group = api.nvim_create_augroup("plugin_whitespace", { clear = true }),
  callback = function() toggle_whitespace("i") end,
})
aucmd("InsertLeave", {
  group = "plugin_whitespace",
  callback = function() toggle_whitespace("n") end,
})

usercmd("WhitespaceErase", function(opts)
  local save_cursor = fn.getpos(".")
  pcall(vim.cmd, string.format("silent! %d,%ds/%s//", opts.line1, opts.line2, ws_pattern))
  fn.setpos(".", save_cursor)
end, { range = "%" })

local function whitespace_jump(direction, line1, line2)
  local opts = "wz"
  local until_line = line2
  if direction < 1 then
    opts = opts .. "b"
    until_line = line1
  end
  if line1 == 1 and line2 == fn.line("$") then until_line = 0 end
  fn.search(normal_pattern, opts, until_line)
end

usercmd("WhitespaceNext", function(opts) whitespace_jump(1, opts.line1, opts.line2) end, { range = "%" })
usercmd("WhitespacePrev", function(opts) whitespace_jump(-1, opts.line1, opts.line2) end, { range = "%" })

-- ═══════════════════════════════════════════════════════════════════════════
-- 3. grep-operator — <leader>G operator for recursive grep on selection
-- ═══════════════════════════════════════════════════════════════════════════

local function grep_operator(motion_type)
  local unnamed_save = fn.getreg('"')
  if motion_type == "v" then
    vim.cmd([[normal! `<v`>y]])
  elseif motion_type == "char" then
    vim.cmd([=[normal! `[y`]]=])
  else
    return
  end

  local pattern = fn.getreg('"')
  local grepprg = fn.expand(vim.o.grepprg)

  if grepprg:find("^grep") then
    api.nvim_echo({ { "Using default external grep" } }, true, {})
    pcall(vim.cmd, "silent grep! -R " .. fn.shellescape(pattern) .. " **/*")
    vim.cmd("copen")
  elseif grepprg:find("^rg") then
    api.nvim_echo({ { "Using ripgrep" } }, true, {})
    pcall(vim.cmd, "silent grep! " .. fn.shellescape(pattern) .. " **/*")
    vim.cmd("copen")
  else
    api.nvim_echo({ { "&grepprg not supported", "WarningMsg" } }, true, {})
  end

  fn.setreg('"', unnamed_save)
end
_G.GrepOperator = grep_operator

vim.keymap.set("n", "<leader>G", function()
  vim.o.operatorfunc = "v:lua.GrepOperator"
  return "g@"
end, { expr = true })
vim.keymap.set("v", "<leader>G", function() grep_operator(fn.visualmode()) end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 4. jumpfile — JumpBuffer() for jumplist buffer-level navigation
-- ═══════════════════════════════════════════════════════════════════════════
-- Called from mappings_vim.lua's ExtendedBasicMappings (g<C-i> / g<C-o>)

local function jump_buffer(direction)
  local jumplist, curjump = unpack(fn.getjumplist())
  local cmdchr = direction > 0
    and api.nvim_replace_termcodes("<C-o>", true, false, true)
    or api.nvim_replace_termcodes("<C-i>", true, false, true)
  local cmdstr = direction > 0 and "<C-o>" or "<C-i>"

  local range = {}
  if direction > 0 then
    for i = curjump - 1, 0, -1 do table.insert(range, i) end
  else
    for i = curjump + 1, #jumplist - 1 do table.insert(range, i) end
  end

  for _, i in ipairs(range) do
    local jump = jumplist[i + 1]  -- Lua 1-indexed
    if jump then
      local bnr = jump.bufnr
      local bname = fn.bufname(bnr)
      if bnr ~= fn.bufnr("%") and not bname:match("^%a+://") then
        local n = math.abs((i - curjump) * direction)
        api.nvim_echo({ { string.format("Executing %s %d times", cmdstr, n) } }, false, {})
        vim.cmd("normal! " .. n .. cmdchr)
        return
      end
    end
  end
end
_G.JumpBuffer = jump_buffer
vim.cmd([[
  function! JumpBuffer(direction) abort
    call v:lua.JumpBuffer(a:direction)
  endfunction
]])

-- ═══════════════════════════════════════════════════════════════════════════
-- 5. quickfixopenall — :QuickFixOpenAll command
-- ═══════════════════════════════════════════════════════════════════════════

local function quickfix_open_all()
  local qflist = fn.getqflist()
  if #qflist == 0 then return end
  local prev = ""
  for _, d in ipairs(qflist) do
    local curr = fn.bufname(d.bufnr)
    if curr ~= prev then vim.cmd("edit " .. fn.fnameescape(curr)) end
    prev = curr
  end
end
_G.QuickFixOpenAll = quickfix_open_all
usercmd("QuickFixOpenAll", quickfix_open_all, {})

-- ═══════════════════════════════════════════════════════════════════════════
-- 6. sessions — SeshSave/Load/Delete/List/Close/Detach
-- ═══════════════════════════════════════════════════════════════════════════

vim.g.session_directory = vim.g.session_directory or (vim.env.DATA_PATH .. "/session")

local function project_name()
  local cwd = fn.resolve(fn.getcwd())
  local home = vim.env.HOME or ""
  if home ~= "" and cwd:sub(1, #home + 1) == home .. "/" then
    cwd = cwd:sub(#home + 2)
  end
  cwd = fn.fnamemodify(cwd, ":p"):gsub("/", "_"):gsub("^%.+", "")
  return cwd
end

local function session_dir() return vim.g.session_directory end

local function session_list(arg_lead)
  local pattern = session_dir() .. "/" .. fn.fnameescape(arg_lead or "") .. "*.vim"
  local files = fn.split(fn.glob(pattern), "\n")
  return vim.tbl_map(function(v) return fn.fnamemodify(v, ":t:r") end, files)
end

local function session_save_current()
  if vim.v.this_session ~= "" and vim.g.SeshLoad == nil then
    pcall(vim.cmd, "mksession! " .. fn.fnameescape(vim.v.this_session))
  end
end

local function session_detach()
  if vim.v.this_session ~= "" and vim.g.SeshLoad == nil then
    vim.cmd("let v:this_session = ''")
    vim.cmd("redrawtabline")
    vim.cmd("redrawstatus")
  end
end

local function buffers_wipeout() pcall(vim.cmd, "noautocmd silent! %bwipeout!") end

local function session_save(name)
  if fn.isdirectory(session_dir()) == 0 then fn.mkdir(session_dir(), "p") end
  local file_name = (name == "" or name == nil) and project_name() or name
  local file_path = session_dir() .. "/" .. file_name .. ".vim"
  vim.cmd("mksession! " .. fn.fnameescape(file_path))
  vim.cmd("let v:this_session = '" .. file_path:gsub("'", "''") .. "'")
  api.nvim_echo({ { "Session `" .. file_name .. "` is now persistent.", "MoreMsg" } }, true, {})
end

local function session_load(name)
  session_save_current()
  local file_name = (name == "" or name == nil) and project_name() or name
  local file_path = session_dir() .. "/" .. file_name .. ".vim"
  if fn.filereadable(file_path) == 1 then
    buffers_wipeout()
    vim.cmd("silent source " .. fn.fnameescape(file_path))
  else
    api.nvim_echo({ { 'The session "' .. file_path .. "\" doesn't exist.", "ErrorMsg" } }, true, {})
  end
end

local function session_delete(name)
  local file_name = (name == "" or name == nil) and project_name() or name
  local file_path = session_dir() .. "/" .. file_name .. ".vim"
  if vim.v.this_session == file_path then session_detach() end
  if fn.filereadable(file_path) == 1 then
    if fn.delete(file_path) == -1 then
      api.nvim_echo({ { 'The session "' .. file_path .. '" deletion failed!', "ErrorMsg" } }, true, {})
    else
      api.nvim_echo({ { 'The session "' .. file_path .. '" is deleted.' } }, true, {})
    end
  else
    api.nvim_echo({ { 'The session "' .. file_path .. "\" doesn't exist.", "ErrorMsg" } }, true, {})
  end
end

local function session_close()
  if vim.v.this_session ~= "" and vim.g.SeshLoad == nil then
    session_save_current()
    session_detach()
    buffers_wipeout()
  end
end

local complete_fn = function(arg_lead) return session_list(arg_lead) end

usercmd("SeshSave", function(opts) session_save(opts.args) end, { nargs = "?", complete = complete_fn })
usercmd("SeshLoad", function(opts) session_load(opts.args) end, { nargs = "?", complete = complete_fn })
usercmd("SeshDelete", function(opts) session_delete(opts.args) end, { nargs = "?", complete = complete_fn })
usercmd("SeshClose", session_close, {})
usercmd("SeshDetach", session_detach, {})
usercmd("SeshList", function()
  vim.cmd('!stat -c "%y %n" ' .. session_dir() .. "/*.vim")
end, {})

aucmd("VimLeavePre", {
  group = api.nvim_create_augroup("plugin_sessions", { clear = true }),
  callback = session_save_current,
})
