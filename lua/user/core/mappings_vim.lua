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

-- ─── FilePathMappings ────────────────────────────────────────────────────────
-- Yank file path/name info to `+` register in various forms.
-- Ref: https://vim.fandom.com/wiki/Get_the_name_of_the_current_file

do
  local function yank_and_echo(modifier, msg)
    return function()
      local val = fn.expand(modifier)
      fn.setreg("+", val)
      print(msg)
    end
  end

  keymap("n", "<Leader>fye", yank_and_echo("%:p:r",  "Yanked absolute file path without extension"))
  keymap("n", "<Leader>fyE", yank_and_echo("%:r",    "Yanked relative file path without extension"))
  keymap("n", "<Leader>fyp", yank_and_echo("%:p",    "Yanked absolute file path"))
  keymap("n", "<Leader>fyP", yank_and_echo("%:~:.",  "Yanked relative file path"))
  keymap("n", "<Leader>fyf", yank_and_echo("%:t:r",  "Yanked file name without extension"))
  keymap("n", "<Leader>fyF", yank_and_echo("%:t",    "Yanked file name"))
  keymap("n", "<Leader>fyd", yank_and_echo("%:p:h",  "Yanked absolute directory path"))
  keymap("n", "<Leader>fyD", yank_and_echo("%:p:h:t", "Yanked relative directory path"))
  keymap("n", "<Leader>fyx", yank_and_echo("%:e",    "Yanked file extension"))

  -- :edit file path from clipboard register
  keymap("n", "<Leader>fyo", function()
    vim.cmd("e " .. fn.getreg("+"))
    print("Opened " .. fn.expand("%:p"))
  end)

  -- gyp/gyP/gyl/gyL: yank to both + and 0
  local function set_plus_and_zero(val)
    fn.setreg("+", val)
    fn.setreg("0", val)
  end
  keymap("n", "gyp", function() set_plus_and_zero(fn.expand("%")) end)
  keymap("n", "gyP", function() set_plus_and_zero(fn.expand("%:p")) end)
  keymap("n", "gyl", function()
    set_plus_and_zero(string.format("%s:%d", fn.expand("%"), fn.getcurpos()[2]))
  end)
  keymap("n", "gyL", function()
    set_plus_and_zero(string.format("%s:%d", fn.expand("%:p"), fn.getcurpos()[2]))
  end)
end

-- ─── FileManagementMappings ──────────────────────────────────────────────────

do
  keymap("n", "<Leader>fD", function()
    local path = fn.expand("%:p")
    vim.api.nvim_echo({ { "File " .. path .. " deleting...", "WarningMsg" } }, true, {})
    fn.delete(fn.expand("%"))
    vim.cmd("bdelete!")
  end)

  -- Set working directory to current file location
  keymap("n", "<Leader>frd", ":cd %:p:h<CR>:pwd<CR>")
  keymap("n", "<Leader>frl", ":lcd %:p:h<CR>:pwd<CR>")

  -- Open current file externally (Linux)
  local function open_with(cmd)
    return function() vim.cmd("silent !" .. cmd .. " \"" .. fn.expand("%:p") .. "\" & disown") end
  end
  keymap("n", "<Leader>oo", open_with("xdg-open"),     { silent = true })
  keymap("n", "<Leader>of", open_with("firefox"),      { silent = true })
  keymap("n", "<Leader>og", open_with("google-chrome"), { silent = true })
end

-- ─── WindowsManagementMappings ───────────────────────────────────────────────

do
  local sopts = { silent = true }

  -- Tab operations
  keymap("n", "<LocalLeader>tn", ":tabnew<CR>", sopts)
  keymap("n", "<LocalLeader>tN", ":-tabnew<CR>", sopts)
  keymap("n", "<LocalLeader>ts", ":tab split<CR>", sopts)
  keymap("n", "<LocalLeader>tq", ":tabclose<CR>", sopts)
  keymap("n", "<LocalLeader>te", ":tabedit<CR>", sopts)
  keymap("n", "<LocalLeader>tm", ":tabmove<CR>", sopts)
  keymap("n", "<LocalLeader>t>", ":tabmove+<CR>", sopts)
  keymap("n", "<LocalLeader>t<", ":tabmove-<CR>", sopts)
  keymap("n", "[t", ":tabprevious<CR>", sopts)
  keymap("n", "]t", ":tabnext<CR>", sopts)
  keymap("n", "]T", ":tablast<CR>", sopts)
  keymap("n", "[T", ":tabfirst<CR>", sopts)
  keymap("n", "<M-[>", "<Cmd>tabp<CR>")
  keymap("n", "<M-]>", "<Cmd>tabn<CR>")
  keymap("n", "<leader>x", "<Cmd>tabc<CR>")

  -- Last active tab tracking
  vim.api.nvim_create_autocmd("TabLeave", {
    group = vim.api.nvim_create_augroup("user_lasttab", { clear = true }),
    callback = function() vim.g.lasttab = fn.tabpagenr() end,
  })
  keymap({ "n", "v" }, "<LocalLeader>tl", function()
    if vim.g.lasttab then vim.cmd("tabn " .. vim.g.lasttab) end
  end, { silent = true })

  -- Buffer navigation
  keymap("n", "]b", ":bnext<CR>", sopts)
  keymap("n", "[b", ":bprevious<CR>", sopts)
  keymap("n", "]B", ":blast<CR>", sopts)
  keymap("n", "[B", ":bfirst<CR>", sopts)

  -- Open all buffers in splits
  keymap("n", "<LocalLeader>boh", ":sba<CR>", sopts)
  keymap("n", "<LocalLeader>bov", ":vert sba<CR>", sopts)

  -- Window-control prefix: <C-w> → [Window]
  keymap("n", "[Window]", "<Nop>")
  keymap("n", "<C-w>", "[Window]", { remap = true })

  -- Cycle through windows
  keymap("n", "[Window]w",     "<C-w><C-w>")
  keymap("n", "[Window]<C-w>", "<C-w><C-w>")
  keymap("n", "[Window]<C-p>", "<C-w><C-p>")

  -- Splits
  keymap("n", "<C-q>", ":<C-u>close<CR>", sopts)
  keymap("n", "[Window]g",  ":<C-u>split<CR>", sopts)
  keymap("n", "[Window]v",  ":<C-u>vsplit<CR>", sopts)
  keymap("n", "[Window]c",  ":<C-u>close<CR>", sopts)
  keymap("n", "<LocalLeader>wg", ":<C-u>split<CR>", sopts)
  keymap("n", "<LocalLeader>wv", ":<C-u>vsplit<CR>", sopts)
  keymap("n", "<LocalLeader>wc", ":<C-u>close<CR>", sopts)
  -- Split + return to previous window
  keymap("n", "[Window]<C-v>", ":vsplit<CR>:wincmd p<CR>", sopts)
  keymap("n", "[Window]<C-g>", ":split<CR>:wincmd p<CR>", sopts)
  keymap("n", "<LocalLeader>wV", ":vsplit<CR>:wincmd p<CR>", sopts)
  keymap("n", "<LocalLeader>wG", ":split<CR>:wincmd p<CR>", sopts)

  -- Switch between splits
  keymap("n", "[Window]h", "<C-w>h", sopts)
  keymap("n", "[Window]j", "<C-w>j", sopts)
  keymap("n", "[Window]k", "<C-w>k", sopts)
  keymap("n", "[Window]l", "<C-w>l", sopts)
  keymap("n", "[Window]\\", "<C-w>p", sopts)
  keymap("n", "<C-h>", "<C-w>h", sopts)
  keymap("n", "<C-j>", "<C-w>j", sopts)
  keymap("n", "<C-k>", "<C-w>k", sopts)
  keymap("n", "<C-l>", "<C-w>l", sopts)

  -- Arrow keys → window resizing
  keymap("n", "<Up>",    ":resize -1<CR>", sopts)
  keymap("n", "<Down>",  ":resize +1<CR>", sopts)
  keymap("n", "<Left>",  ":vertical resize -2<CR>", sopts)
  keymap("n", "<Right>", ":vertical resize +2<CR>", sopts)

  -- Equalize splits
  keymap("n", "[Window]=", ":tabdo wincmd =<CR>", sopts)
end

-- ─── UtilityMappings ─────────────────────────────────────────────────────────

do
  keymap("n", "<Leader>ps", "<cmd>source $MYVIMRC<CR>")

  -- Undo break points on common punctuation
  keymap("i", ",", ",<C-g>u")
  keymap("i", ".", ".<C-g>u")
  keymap("i", "!", "!<C-g>u")
  keymap("i", "?", "?<C-g>u")

  -- Select last inserted characters
  keymap("i", "<M-v>", "<ESC>v`[")

  -- Backspace as % (matching pairs)
  keymap({ "n", "x" }, "<BS>", "%")

  -- Insert blank line without entering insert mode
  keymap("n", "[<space>", "O<esc>j")
  keymap("n", "]<space>", "o<esc>k")

  -- Drag current line(s) vertically and auto-indent
  keymap("n", "<Leader>J", ":m.+1<CR>")
  keymap("n", "<Leader>K", ":m.-2<CR>")
  keymap("v", "J", ":m'>+1<CR>gv=gv")
  keymap("v", "K", ":m'<-2<CR>gv=gv")

  -- Popup menu navigation in insert mode
  keymap("i", "<C-j>", function() return fn.pumvisible() == 1 and "<Down>" or "<C-j>" end, { expr = true })
  keymap("i", "<C-k>", function() return fn.pumvisible() == 1 and "<Up>" or "<C-k>" end, { expr = true })

  -- Vimgrep wrapper (function still in mappings.vim as vimscript)
  keymap("n", "<Leader>fg", [[:call VimgrepWrapper("")<Left><Left>]])
  keymap("n", "<Leader>gD", ":GitOpenDirty<CR>")
end

-- ─── CommandMappings ─────────────────────────────────────────────────────────

do
  -- Commandline basic movements (emacs-style)
  keymap("c", "<C-a>", "<Home>")
  keymap("c", "<C-e>", "<End>")
  keymap("c", "<C-d>", "<Del>")
  keymap("c", "<C-h>", "<BS>")

  -- Insert current buffer's directory path
  keymap("c", "<C-t>", function() return fn.expand("%:p:h") .. "/" end, { expr = true })

  -- Wildmenu navigation
  keymap("c", "<C-j>", function()
    return fn.pumvisible() == 1 and "<C-n>" or fn.nr2char(vim.o.wildcharm)
  end, { expr = true })
  keymap("c", "<C-k>", function()
    return fn.pumvisible() == 1 and "<C-p>" or fn.nr2char(vim.o.wildcharm)
  end, { expr = true })
  keymap("c", "<Tab>", function()
    if fn.pumvisible() == 1 then
      return "<C-y>" .. fn.nr2char(vim.o.wildcharm)
    end
    return fn.nr2char(vim.o.wildcharm)
  end, { expr = true })

  -- %% expands to current file's directory
  keymap("c", "%%", function() return fn.fnameescape(fn.expand("%:h")) .. "/" end, { expr = true })

  -- Quick edit in current file's directory
  keymap({ "n", "x", "o" }, "<leader>ew", ":e %%", { remap = true })
  keymap({ "n", "x", "o" }, "<leader>ev", ":vsplit %%", { remap = true })
  keymap({ "n", "x", "o" }, "<leader>eg", ":split %%", { remap = true })
  keymap({ "n", "x", "o" }, "<leader>et", ":tabe %%", { remap = true })
end
