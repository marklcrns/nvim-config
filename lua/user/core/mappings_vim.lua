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
      vim.cmd.echo(vim.fn.string(msg))
      fn.setreg("+", val)
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
    vim.cmd.echo(vim.fn.string("Opened " .. fn.expand("%:p")))
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

-- ─── YankPasteMappings ───────────────────────────────────────────────────────

do
  -- Duplicate line(s) and substitute (uses register "x)
  -- Ref: https://stackoverflow.com/a/3806683/11850077
  keymap("n", "<leader>rp", [["xyap}"xpV`[v`]:s//gcI<Left><Left><Left><Left>]])
  keymap("v", "<Leader>rp", [["xy`]"xp`[v`]:s//gcI<Left><Left><Left><Left>]])

  -- Yank + paste line under cursor
  keymap("n", "<M-y>", [["xyy"xp$]])
  keymap("i", "<M-y>", [[<Esc>"xyy"xpgi]])
  keymap("i", "<C-y>", [[<Esc>"xyy"xpV:s//gI<bar>norm`.A<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]])
  keymap("v", "<M-y>", [=["xy`]"xp`[V`]]=])

  -- Auto-indent on paste via vim-dispatch-style autocmd → sets p/P buffer-local
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("user_auto_indent_paste", { clear = true }),
    callback = function() vim.fn.AutoIndentPaste() end,
  })
end

-- ─── EmacsLikeMappings ───────────────────────────────────────────────────────

do
  -- Insert-mode cursor navigation (emacs bindings)
  keymap("i", "<C-a>", "<Home>")
  keymap("i", "<C-e>", function() return fn.pumvisible() == 1 and "<C-e>" or "<End>" end, { expr = true })
  keymap("i", "<C-p>", "<Up>")
  keymap("i", "<C-n>", "<Down>")
  keymap("i", "<C-b>", "<Left>")
  keymap("i", "<C-f>", "<Right>")

  -- Move between words
  keymap("i", "<M-f>", "<Esc>lwi")
  keymap("i", "<M-b>", "<Esc>bi")
  keymap("i", "<M-S-f>", "<Esc>lWi")
  keymap("i", "<M-S-b>", "<Esc>Bi")

  -- Move between sentences
  keymap("i", "<M-a>", "<Esc>`^(i")
  keymap("i", "<M-e>", "<Esc>`^)i")

  -- Commandline emacs bindings
  keymap("c", "<C-p>", "<Up>")
  keymap("c", "<C-n>", "<Down>")
  keymap("c", "<C-b>", "<Left>")
  keymap("c", "<C-f>", "<Right>")
  -- NOTE: <C-a> <C-e> <C-d> <C-h> <Tab> <C-j> <C-k> in cmdline already set in Phase 2 CommandMappings
  keymap("c", "<C-k>", "<C-f>D<C-c><C-c>:<Up>")
end

-- ─── QuickFixLocationListMappings ────────────────────────────────────────────

do
  local sopts = { silent = true }

  -- Loclist nav
  keymap("n", "[l", ":lprevious<CR>", sopts)
  keymap("n", "]l", ":lnext<CR>", sopts)
  keymap("n", "[L", ":lfirst<CR>", sopts)
  keymap("n", "]L", ":llast<CR>", sopts)

  -- Quickfix nav
  keymap("n", "[q", ":cprevious<CR>", sopts)
  keymap("n", "]q", ":cnext<CR>", sopts)
  keymap("n", "[Q", ":cfirst<CR>", sopts)
  keymap("n", "]Q", ":clast<CR>", sopts)

  -- Toggle loclist/quickfix windows
  keymap("n", "<LocalLeader>oll", ":call LocationlistToggle()<CR>", sopts)
  keymap("n", "<LocalLeader>oqq", ":call QuickfixToggle()<CR>", sopts)

  -- dd in quickfix window → :RemoveQFItem (defined as vimscript command)
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_qf_dd", { clear = true }),
    pattern = "qf",
    callback = function()
      vim.keymap.set("n", "dd", ":RemoveQFItem<CR>", { buffer = true })
    end,
  })
end

-- ─── RegisterMappings ────────────────────────────────────────────────────────
-- Cycle through vim registers +abjkx.
-- `+` = system clipboard, `x` = temp holder. `j` cycles forward, `k` cycles backward.

do
  -- Rotate forward: x=k, k=j, j=b, b=a, a=+, +=x
  local cycle_fwd = [[:let @x=@k | let @k=@j | let @j=@b | let @b=@a | let @a=@+ | let @+=@x | reg +abjk<CR>]]
  -- Rotate backward: x=+, +=a, a=b, b=j, j=k, k=x
  local cycle_bwd = [[:let @x=@+ | let @+=@a | let @a=@b | let @b=@j | let @j=@k | let @k=@x | reg +abjk<CR>]]

  keymap("n", "<Leader>rej", cycle_fwd)
  keymap("n", "<Leader>rek", cycle_bwd)

  -- Cycle then paste
  keymap("n", "<Leader>reJ", cycle_fwd .. "p")
  keymap("n", "<Leader>reK", cycle_bwd .. "p")
  keymap("v", "<Leader>reJ", cycle_fwd .. "p")
  keymap("v", "<Leader>reK", cycle_bwd .. "p")

  -- Copy visual selection then cycle
  keymap("v", "<Leader>rej", "y<ESC>" .. cycle_fwd)
  keymap("v", "<Leader>rek", "y<ESC>" .. cycle_bwd)

  -- Display registers
  keymap("n", "<Leader>reg", ":reg +abjk<CR>")
end

-- ─── DiffMappings ────────────────────────────────────────────────────────────

do
  if vim.o.wildcharm == 0 then vim.o.wildcharm = vim.fn.char2nr("\t") end

  keymap("n", "<Leader>tdv", [[:call feedkeys(':vert diffsplit<Space><Tab>','t')<CR>]])
  keymap("n", "<Leader>tdh", [[:call feedkeys(':diffsplit<Space><Tab>','t')<CR>]])
  keymap("n", "<Leader>tdV", [[:call feedkeys(':vert diffsplit $HOME/<Tab>','t')<CR>]])
  keymap("n", "<Leader>tdH", [[:call feedkeys(':diffsplit $HOME/<Tab>','t')<CR>]])
  keymap("n", "<Leader>tdo", ":DiffOrig<CR>", { silent = true, remap = true })

  -- Diff mode help messages (shown once per diff mode activation)
  local function print_merge_diff_mappings()
    if vim.g.custom_diff_enable == 1 then return end

    -- Diff-mode-only git mergetool shortcuts
    local function diff_expr(cmd) return function() return vim.wo.diff and cmd or "" end end
    keymap("n", "db", diff_expr(":diffget BASE<CR>"), { expr = true })
    keymap("n", "dl", diff_expr(":diffget LOCAL<CR>"), { expr = true })
    keymap("n", "dr", diff_expr(":diffget REMOTE<CR>"), { expr = true })
    keymap("n", "cq", diff_expr(":cquit<CR>"), { expr = true })

    local msgs = {
      " ",
      "dp :diffput",
      "do :diffget",
      "db :diffget BASE (git mergetool only)",
      "dl :diffget LOCAL (git mergetool only)",
      "dr :diffget REMOTE (git mergetool only)",
      "cq :cquit",
      "]c or ]x Next conflict",
      "[c or [x Previous conflict",
    }
    for _, m in ipairs(msgs) do vim.api.nvim_echo({ { m } }, true, {}) end

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
end

-- ─── FoldsMappings ───────────────────────────────────────────────────────────

do
  keymap("n", "<Leader>z", "za")
  keymap("n", "<Leader>Z", "zMzvzt")
  keymap("n", "zm", function() return vim.wo.foldlevel ~= 0 and "zM" or "zR" end, { expr = true })

  -- NextClosedFold / NextOpenFold are vimscript globals in mappings.vim
  keymap("n", "zj", function() vim.fn.NextClosedFold("j") end, { silent = true })
  keymap("n", "zk", function() vim.fn.NextClosedFold("k") end, { silent = true })
  keymap("n", "zn", function() vim.fn.NextOpenFold("j") end, { silent = true })
  keymap("n", "zp", function() vim.fn.NextOpenFold("k") end, { silent = true })
end

-- ─── SessionMappings ─────────────────────────────────────────────────────────

do
  keymap("n", "<Leader>ss", ":<C-u>SeshSave<Space>")
  keymap("n", "<Leader>sl", [[:<C-u>call feedkeys(':SeshLoad<Space><Tab>','t')<CR>]])
  keymap("n", "<Leader>sD", [[:<C-u>call feedkeys(':SeshDelete<Space><Tab>','t')<CR>]])
  keymap("n", "<Leader>sL", ":<C-u>SeshList<CR>")
  keymap("n", "<Leader>sq", ":<C-u>SeshClose<CR>")
  keymap("n", "<Leader>sd", ":<C-u>SeshDetach<CR>")
end

-- ─── TextManipulationMappings ────────────────────────────────────────────────

do
  -- whitespace.vim
  keymap("n", "<Leader>r<Space>", ":<C-u>WhitespaceErase<CR>", { silent = true })
  keymap("v", "<Leader>r<Space>", ":WhitespaceErase<CR>", { silent = true })

  -- Change current word (repeatable with .)
  keymap("n", "<leader>rw", "*``cgn")
  keymap("n", "<leader>rW", "*``cgN")

  -- Change selected word (repeatable with .)
  keymap("v", "<leader>rn", [[y/\V<C-r>=escape(@", '/')<CR><CR>``cgn]], { expr = false })
  keymap("v", "<leader>rN", [[y/\V<C-r>=escape(@", '/')<CR><CR>``cgN]], { expr = false })
  keymap("n", "<leader>rn", [[yiw/\V<C-r>=escape(@", '/')<CR><CR>``cgn]], { expr = false })
  keymap("n", "<leader>rN", [[yiw/\V<C-r>=escape(@", '/')<CR><CR>``cgN]], { expr = false })

  -- Search and replace
  keymap("n", "<Leader>rr", ":%s//gc<Left><Left><Left>")
  keymap("n", "<Leader>rR", ":s//gc<Left><Left><Left>")
  keymap("x", "<Leader>rr", ":s//gc<Left><Left><Left>")

  -- Search and replace last visual selection
  keymap("n", "<Leader>rF", [[:<C-u>call GetSelection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>]])
  keymap("x", "<Leader>rF", [[:<C-u>call GetSelection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>]])

  -- Enumerate lines
  keymap("n", "<Leader>rL", [[:%s/^/\=line('.').". "<CR>]])
  keymap("v", "<Leader>rl", [[:<C-U>let i=1 | '<,'>g/^/s//\=i.'. '/ | let i=i+1 | nohl<CR>]], { silent = true })

  -- Indent whole buffer (preserving cursor + search)
  keymap("n", "<Leader>ri", [[:call Preserve("normal gg=G")<CR>]], { silent = true })

  -- Yank entire file without moving cursor
  keymap("n", "<Leader>rya", ":%y<CR>")
  -- Replace all with yanked text
  keymap("n", "<Leader>ryp", [[ggVGP:echom "Replaced all with yanked texts!"<CR>]])

  -- SmartPaste
  keymap("n", "<Leader>rP", "<cmd>call SmartPaste()<CR>", { silent = true })

  -- Spell: jump to previous misspelled word, auto-fix with first suggestion
  keymap("i", "<C-s>", [[<Esc>:set spell<bar>norm i<C-g>u<Esc>[s"syiW1z="tyiW:let @l=line('.')<bar>let @c=virtcol('.')<CR>``a<C-g>u<Esc>:echo getreg('l') . ":" . getreg('c') . " spell fixed (" . getreg('s') . " -> " . getreg('t') . ")"<CR>la]])

  -- Toggle spell
  keymap("n", "<F11>", ":set spell!<CR>")
  keymap("i", "<F11>", "<C-o>:set spell!<CR>")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PHASE 4 — Remaining helpers + SettingsToggleMappings + EliteModeToggle
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── Remaining helpers ───────────────────────────────────────────────────────

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
  if ft == "markdown" or ft == "text" or ft == "snippets" or ft == "tex" then
    return
  end
  vim.keymap.set("n", "p", "p=`]", { buffer = 0 })
  vim.keymap.set("n", "P", "P=`]", { buffer = 0 })
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
      vim.cmd("lclose")
      return
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
      vim.cmd("cclose")
      return
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
  table.remove(qflist, idx + 1)  -- Lua 1-indexed
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
  if open then
    fn.winrestview(view)
  end
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
    while fn.foldclosed(start) ~= -1 do
      start = start + 1
    end
    fn.cursor(start, 0)
  else
    vim.cmd("normal zk")
    local start = fn.line(".")
    while fn.foldclosed(start) ~= -1 do
      start = start - 1
    end
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
    [[gv:s/“/"/ge]],
    [[gv:s/”/"/ge]],
    [[gv:s/’/'/ge]],
    [[gv:s/—/--/ge]],
    [[gv:s/…/.../ge]],
    [[gv:s/•/-/ge]],
    [[gv:s/ ,/,/ge]],
    [[gv:s/  /\r\r/ge]],
    [[gv:s/   / /ge]],
    [[gv:s/ \././ge]],
    [[gv:s/​//ge]],
    -- Escape unprefixed currency: $10,000 -> \$10,000
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

local toggles = {}

function toggles.conceal()
  if vim.o.conceallevel ~= 0 then
    vim.o.conceallevel = 0
    vim.api.nvim_echo({ { "Conceallevel 0" } }, true, {})
  else
    vim.o.conceallevel = 3
    vim.api.nvim_echo({ { "Conceallevel 3" } }, true, {})
  end
end

function toggles.foldcolumn1()
  if vim.o.foldcolumn == "0" then
    vim.o.foldcolumn = "1"
    vim.api.nvim_echo({ { "Foldcolumn 1" } }, true, {})
  else
    vim.o.foldcolumn = "0"
    vim.api.nvim_echo({ { "Foldcolumn 0" } }, true, {})
  end
end

function toggles.gutter()
  if vim.o.signcolumn == "yes" then
    vim.o.signcolumn = "no"
    vim.api.nvim_echo({ { "Sign gutter deactivated" } }, true, {})
  else
    vim.o.signcolumn = "yes"
    vim.api.nvim_echo({ { "Sign gutter activated" } }, true, {})
  end
end

function toggles.virtualedit()
  if vim.o.virtualedit == "" then
    vim.o.virtualedit = "all"
    vim.api.nvim_echo({ { "Virtualedit activated" } }, true, {})
  else
    vim.o.virtualedit = ""
    vim.api.nvim_echo({ { "Virtualedit deactivated" } }, true, {})
  end
end

function toggles.text_wrapping()
  if not vim.o.formatoptions:find("t", 1, true) then
    vim.opt.formatoptions:append("t")
    vim.api.nvim_echo({ { "Text wrapping activated" } }, true, {})
  else
    vim.opt.formatoptions:remove("t")
    vim.api.nvim_echo({ { "Text wrapping deactivated" } }, true, {})
  end
end

function toggles.background()
  local scheme = vim.g.colors_name
  if not scheme then
    vim.api.nvim_echo({ { "No colorscheme set" } }, true, {})
    return
  end
  if scheme:match("dark") or scheme:match("light") then
    local new = scheme:match("dark") and scheme:gsub("dark", "light") or scheme:gsub("light", "dark")
    vim.cmd("colorscheme " .. new)
  else
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
    if not vim.g.colors_name then
      vim.cmd("colorscheme " .. scheme)
      vim.api.nvim_echo(
        { { "The colorscheme `" .. scheme .. "` doesn't have background variants!" } },
        true, {})
    else
      vim.api.nvim_echo({ { "Set colorscheme to " .. vim.o.background .. " mode" } }, true, {})
    end
  end
end

function toggles.format_on_save()
  if vim.g.enable_format_on_save then
    vim.g.enable_format_on_save = false
    vim.api.nvim_echo({ { "Format on save deactivated" } }, true, {})
  else
    vim.g.enable_format_on_save = true
    vim.api.nvim_echo({ { "Format on save activated" } }, true, {})
  end
end

function toggles.low_performance_mode()
  if vim.g.low_performance_mode then
    vim.api.nvim_echo({ { "Low performance mode OFF. Restart nvim to take effect" } }, true, {})
    vim.g.low_performance_mode = false
    if _G.CacheToDataDir then _G.CacheToDataDir("low_performance_mode", false) end
  else
    vim.api.nvim_echo({ { "Low performance mode ON. Restart nvim to take effect" } }, true, {})
    vim.g.low_performance_mode = true
    if _G.CacheToDataDir then _G.CacheToDataDir("low_performance_mode", true) end
  end
end

-- ─── SettingsToggleMappings ──────────────────────────────────────────────────

do
  local sopts = { silent = true }
  keymap("n", "<LocalLeader>se", toggles.conceal, sopts)
  keymap("n", "<LocalLeader>ss", toggles.format_on_save, sopts)
  keymap("n", "<LocalLeader>sF", toggles.foldcolumn1, sopts)
  keymap("n", "<LocalLeader>sg", toggles.gutter, sopts)
  keymap("n", "<LocalLeader>sv", toggles.virtualedit, sopts)
  keymap("n", "<LocalLeader>sW", toggles.text_wrapping, sopts)
  keymap("n", "<LocalLeader>sb", toggles.background, sopts)
  keymap("n", "<LocalLeader>sL", toggles.low_performance_mode)

  -- Smart wrap toggle (breakindent + colorcolumn toggle together)
  keymap("n", "<LocalLeader>sw", function()
    local cc = vim.wo.colorcolumn == "" and tostring(vim.bo.textwidth) or ""
    vim.cmd("setlocal wrap! breakindent! colorcolumn=" .. cc)
  end)
end

-- ─── EliteModeToggle ─────────────────────────────────────────────────────────

keymap("n", "<LocalLeader>sE", elite_mode_toggle)
