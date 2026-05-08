-- Port of core/mappings.vim — Phase 1
-- Covers: helpers (AddSubtract, ShiftCharAscii, VShiftCharAscii, LazyNorm),
--         ExitMappings, ImprovedDefaultMappings, ExtendedBasicMappings,
--         OperatorMappings.
-- Other helpers/mappings remain in core/mappings.vim pending future phases.

local fn = vim.fn
local keymap = vim.keymap.set

-- ─── Leaders ─────────────────────────────────────────────────────────────────

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Release keymap prefixes for plugin use
keymap({ "n", "x" }, "<Space>", "<Nop>")
keymap({ "n", "x" }, ",", "<Nop>")
keymap({ "n", "x" }, ";", "<Nop>")

-- ─── Helpers ─────────────────────────────────────────────────────────────────

--- Increment/Decrement integer. Uses <C-a>/<C-x> internally.
--- @param char string  -- terminal representation of <C-a> or <C-x>
--- @param back "" | "b"  -- "b" for backward search
local function add_subtract(char, back)
  local pattern = vim.o.nrformats:match("alpha") and "[[:alpha:][:digit:]]" or "[[:digit:]]"
  fn.search(pattern, "cw" .. back)
  vim.cmd("normal! " .. vim.v.count1 .. char)
  -- Preserve dot-repeat via vim-repeat if available
  pcall(fn["repeat#set"], vim.api.nvim_replace_termcodes(
    ":<C-u>call AddSubtract('" .. char .. "', '" .. back .. "')<CR>", true, false, true))
end
-- Expose for any legacy callers (vim-repeat callback)
_G.AddSubtract = add_subtract
-- Also register as vimscript function so legacy `:call AddSubtract(...)` works
vim.cmd([[
  function! AddSubtract(char, back) abort
    call v:lua.AddSubtract(a:char, a:back)
  endfunction
]])

--- Shift single char's ASCII code (normal mode: operates on char under cursor)
local function shift_char_ascii(char, shift)
  local nr = fn.char2nr(char)
  vim.cmd("normal! r" .. fn.nr2char(nr + shift))
end
_G.ShiftCharAscii = shift_char_ascii

--- Shift ASCII codes for visual-selected text. Replaces selection with shifted text.
local function v_shift_char_ascii(shift)
  local start_pos = fn.getpos("'<")
  local end_pos = fn.getpos("'>")
  local line_start, col_start = start_pos[2], start_pos[3]
  local line_end, col_end = end_pos[2], end_pos[3]
  local lines = fn.getline(line_start, line_end)
  if #lines == 0 then return end

  -- Trim to exact selection
  lines[#lines] = lines[#lines]:sub(1, col_end)
  lines[1] = lines[1]:sub(col_start)

  local str = table.concat(lines, "\n")
  local chars = {}
  for i = 1, #str do
    table.insert(chars, fn.nr2char(fn.char2nr(str:sub(i, i)) + shift))
  end
  local res = table.concat(chars)

  local clipboard = fn.getreg("+")
  fn.setreg("+", res)
  vim.cmd("normal! gvpgv")
  fn.setreg("+", clipboard)
end
_G.VShiftCharAscii = v_shift_char_ascii

--- Temporarily set 'lazyredraw' and run a normal-mode command.
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

-- ─── ExitMappings ────────────────────────────────────────────────────────────

do
  local sopts = { silent = true }
  keymap("n", "Q", "q")
  keymap("n", "q", ":q<CR>")
  keymap("n", "<Leader>q", ":q!<CR>", sopts)
  keymap("x", "<Leader>q", "<Esc>:q!<CR>", sopts)
  keymap("n", "<Leader>Q", ":qa!<CR>", sopts)
  keymap("x", "<Leader>Q", "<Esc>:qa!<CR>", sopts)
  keymap("n", "<leader>fs", ":CustomBufferWrite<CR>", sopts)
  keymap("x", "<leader>fs", "<Esc>:CustomBufferWrite<CR>", sopts)
  keymap("n", "<leader>fa", ":CustomBufferWrite a<CR>", sopts)
  keymap("x", "<leader>fa", "<Esc>:CustomBufferWrite a<CR>", sopts)
  keymap("n", "<leader>fq", ":CustomBufferWrite q<CR>", sopts)
  keymap("x", "<leader>fq", "<Esc>:CustomBufferWrite q<CR>", sopts)
  keymap("n", "<leader>fw", ":bw<CR>", sopts)
  keymap("x", "<leader>fw", ":<Esc>bw<CR>", sopts)
  keymap("n", "<leader>fQ", ":confirm wqa!<CR>")
  keymap("x", "<leader>fQ", ":<Esc>confirm wqa!<CR>")
end

-- ─── ImprovedDefaultMappings ─────────────────────────────────────────────────

do
  -- Use lazyredraw when replaying macro
  keymap("n", "@", function()
    lazy_norm(vim.v.count1 .. "@" .. fn.getcharstr())
  end)
  keymap("n", "@@", function() lazy_norm(vim.v.count1 .. "@@") end)

  -- Keep cursor at end of visual selection after yanking
  keymap("v", "y", "ygv<Esc>")
  keymap("n", "Y", "y$")
  -- Don't overwrite clipboard when pasting over selection
  keymap("x", "p", "pgvy")

  -- Don't pollute default register with x/c/s
  local m = { "n", "x" }
  keymap(m, "x", [["_x]])
  keymap(m, "X", [["_X]])
  keymap(m, "c", [["_c]])
  keymap(m, "C", [["_C]])
  keymap(m, "s", [["_s]])
  keymap(m, "S", [["_S]])

  -- Re-select block after indent
  keymap("x", "<", "<gv")
  keymap("x", ">", ">gv|")

  -- Keep centered when jumping and unfold
  keymap("n", "n", "nzzzv")
  keymap("n", "N", "Nzzzv")

  -- Keep cursor when joining lines
  keymap("n", "J", function()
    local p = fn.getpos(".")
    vim.cmd("join")
    fn.setpos(".", p)
  end, { silent = true })

  -- Fix [c/]c
  keymap("n", "[c", "[c")
  keymap("n", "]c", "]c")

  -- Side scroll step
  keymap("n", "zl", "z4l")
  keymap("n", "zh", "z4h")

  -- Open file under cursor in vsplit
  keymap("n", "go", ":vertical wincmd f<CR>")

  -- Relative-number jumps that respect wrap
  local function gj_gk(base)
    return function() return vim.v.count == 0 and ("g" .. base) or base end
  end
  keymap({ "n", "v" }, "j", gj_gk("j"), { silent = true, expr = true })
  keymap({ "n", "v" }, "k", gj_gk("k"), { silent = true, expr = true })

  -- Paragraph jumps without polluting jumplist
  keymap("n", "}", function()
    vim.cmd("keepjumps norm! " .. vim.v.count1 .. "}")
  end, { silent = true })
  keymap("n", "{", function()
    vim.cmd("keepjumps norm! " .. vim.v.count1 .. "{")
  end, { silent = true })

  -- Increment/decrement with search-next / search-previous
  local ca = vim.api.nvim_replace_termcodes("<C-a>", true, false, true)
  local cx = vim.api.nvim_replace_termcodes("<C-x>", true, false, true)
  keymap("n", "<C-a>", function() add_subtract(ca, "") end, { silent = true })
  keymap("n", "<C-x>", function() add_subtract(cx, "") end, { silent = true })
  keymap("n", "<C-S-a>", function() add_subtract(ca, "b") end, { silent = true })
  keymap("n", "<C-S-x>", function() add_subtract(cx, "b") end, { silent = true })

  -- Improved scroll (credits: Shougo)
  keymap({ "n", "v" }, "<C-f>", function()
    local n = math.max(fn.winheight(0) - 2, 1)
    local tail = (fn.line("w$") >= fn.line("$")) and "L" or "M"
    return n .. "<C-d>" .. tail
  end, { expr = true })
  keymap({ "n", "v" }, "<C-b>", function()
    local n = math.max(fn.winheight(0) - 2, 1)
    local tail = (fn.line("w0") <= 1) and "H" or "M"
    return n .. "<C-u>" .. tail
  end, { expr = true })
  keymap({ "n", "v" }, "<C-e>", function()
    return (fn.line("w$") >= fn.line("$")) and "j" or "3<C-e>"
  end, { expr = true })
  keymap({ "n", "v" }, "<C-y>", function()
    return (fn.line("w0") <= 1) and "k" or "3<C-y>"
  end, { expr = true })

  -- Close pumvisible before inserting newline
  keymap("i", "<M-o>", function()
    return (fn.pumvisible() == 1) and "<C-e><C-o>o" or "<C-o>o"
  end, { expr = true })
  keymap("i", "<M-O>", function()
    return (fn.pumvisible() == 1) and "<C-e><C-O>O" or "<C-O>O"
  end, { expr = true })
end

-- ─── ExtendedBasicMappings ───────────────────────────────────────────────────

do
  -- Terminal: Esc → normal mode
  keymap("t", "<Esc>", [[<C-\><C-n>]])

  -- Esc shortcuts in insert/visual/command modes
  keymap("i", "fd", "<Esc>`^", { remap = true })
  keymap("i", "kj", "<Esc>`^", { remap = true })
  keymap("v", "fd", "<Esc>`<")
  keymap("v", "df", "<Esc>`>")
  keymap("c", "<C-[>", "<C-c>")
  keymap("c", "<C-g>", "<C-c>")

  -- Insert actual tab with <S-Tab>
  keymap("i", "<S-Tab>", "<C-v><Tab>")

  -- Easier line-wise movement
  keymap("n", "gh", "g^")
  keymap("n", "gl", "g$")

  -- Jump entire buffers in jumplist (JumpBuffer defined in plugin/jumpfile.vim)
  keymap("n", "g<C-i>", ":<C-u>call JumpBuffer(-1)<CR>")
  keymap("n", "g<C-o>", ":<C-u>call JumpBuffer(1)<CR>")

  -- Insert newline below
  keymap("i", "<S-CR>", "<C-o>o")

  -- Resize tab windows after top/bottom window movement
  keymap("n", "<C-w>K", "<C-w>K<C-w>=")
  keymap("n", "<C-w>J", "<C-w>J<C-w>=")

  -- Select last paste
  keymap("n", "gp", function()
    return "`[" .. fn.getregtype():sub(1, 1) .. "`]"
  end, { expr = true })

  -- Center search results with lazyredraw
  keymap("n", "n", function()
    vim.o.hlsearch = true
    lazy_norm(vim.v.searchforward == 1 and "nzz" or "Nzz")
  end)
  keymap("n", "N", function()
    vim.o.hlsearch = true
    lazy_norm(vim.v.searchforward == 1 and "Nzz" or "nzz")
  end)

  keymap("n", "<C-o>", "<C-o>zz")
  keymap("n", "<C-i>", "<C-i>zz")

  -- Shift char ASCII
  keymap("v", "<M-c>", function() v_shift_char_ascii(1) end, { silent = true })
  keymap("v", "<M-S-c>", function() v_shift_char_ascii(-1) end, { silent = true })
  keymap("n", "<M-c>", function()
    local line = fn.getline(".")
    local col = fn.col(".")
    local char = line:sub(col, col)
    if char ~= "" then shift_char_ascii(char, 1) end
  end, { silent = true })
  keymap("n", "<M-S-c>", function()
    local line = fn.getline(".")
    local col = fn.col(".")
    local char = line:sub(col, col)
    if char ~= "" then shift_char_ascii(char, -1) end
  end, { silent = true })
end

-- ─── OperatorMappings ────────────────────────────────────────────────────────

do
  -- Inside/around next/last parenthesis
  keymap("o", "in(", ":<C-u>normal! f(vi(<CR>")
  keymap("o", "il(", ":<C-u>normal! F)vi(<CR>")
  keymap("o", "an(", ":<C-u>normal! f(va(<CR>")
  keymap("o", "al(", ":<C-u>normal! F)va(<CR>")
end
