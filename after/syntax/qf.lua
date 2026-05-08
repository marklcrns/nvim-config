-- NOTE: These patterns assume the qf format provided by nvim-pqf.
--
-- Conceal state semantics (matches original vimscript):
--   -2 = UNSET
--   -1 = CLEARED
--   >=0 = SET (holds matchadd id)

vim.cmd([[
  syn match qfPathBasename /\v(.{-})(:\d+(:\d+)?)@=/ nextgroup=qfPosition contained
  syn match qfPath /\v(\S*\/)?/ nextgroup=qfPathBasename contained

  hi! link qfPath Comment
  hi def link qfPathBasename Keyword
]])

-- Buffer-local conceal pattern + id tracking (persists across window switches)
if not vim.b.qf_conceal_state then
  vim.b.qf_conceal_state = {
    dir = { pattern = [[\v(\S*\/)]], id = -2 },
    basename = { pattern = [[\v(\S*\/)\zs(.{-})\ze(:\d+:\d+)]], id = -2 },
    pos = { pattern = [[\v(:\d+:\d+)]], id = -2 },
  }
end

-- Window-local match id tracking
if not vim.w.qf_conceal_state then
  vim.w.qf_conceal_state = {
    dir = { id = -2 },
    basename = { id = -2 },
    pos = { id = -2 },
  }
end

local function set_conceal_path(target, flag)
  local w_state = vim.w.qf_conceal_state
  local b_state = vim.b.qf_conceal_state
  local id = w_state[target].id
  local pattern = b_state[target].pattern

  if flag then
    if id < 0 then
      w_state[target].id = vim.fn.matchadd("Conceal", pattern)
    end
  else
    if id > -1 then
      pcall(vim.fn.matchdelete, id)
      w_state[target].id = -1
    end
  end

  b_state[target].id = w_state[target].id
  -- Reassign to trigger vim.b/vim.w serialization
  vim.w.qf_conceal_state = w_state
  vim.b.qf_conceal_state = b_state
end

local function toggle_conceal_path()
  local dir_id = vim.b.qf_conceal_state.dir.id
  set_conceal_path("dir", dir_id < 0)
end

vim.keymap.set("n", "<M-o>", toggle_conceal_path, { buffer = true })

-- Auto-conceal dir for help/man loclists
local loclist = vim.fn.getloclist(0)
if vim.b.qf_conceal_state.dir.id == -2 and #loclist > 0 then
  local bufname = vim.fn.bufname(loclist[1].bufnr)
  if bufname:match(".*/runtime/doc/.*") or bufname:match("^man://.*") then
    set_conceal_path("dir", true)
  end
else
  set_conceal_path("dir", vim.b.qf_conceal_state.dir.id > -1)
end
