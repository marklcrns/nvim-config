-- Port of core/general.vim — all editor settings

local fn = vim.fn
local opt = vim.opt
local g = vim.g

-- ─── General ─────────────────────────────────────────────────────────────────

opt.mouse = "nv"
opt.report = 0
opt.errorbells = true
opt.visualbell = true
opt.confirm = true
opt.hidden = true
opt.fileformats = { "unix", "dos", "mac" }
opt.magic = true
opt.path:append("**")
opt.isfname:remove("=")
opt.virtualedit = "block"
opt.synmaxcol = 2500
opt.formatoptions:append("1qtnj")
opt.formatoptions:remove("o")
opt.spelllang = { "en", "cjk" }
opt.spellsuggest = { "best", "9" }
opt.jumpoptions = "stack"
opt.encoding = "utf-8"

-- Views and sessions
opt.viewoptions = { "folds", "cursor", "curdir", "slash", "unix" }
opt.sessionoptions = { "curdir", "help", "tabpages", "winsize" }

-- macOS clipboard
if fn.has("mac") == 1 then
  g.clipboard = {
    name = "macOS-clipboard",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 0,
  }
-- OSC 52 clipboard for SSH / headless sessions (no X/Wayland display).
-- Terminal (kitty/iTerm2/WezTerm/Alacritty/tmux) passes the copy sequence
-- through to the local system clipboard. Paste via OSC 52 is rarely
-- implemented; fall back to internal registers or tmux buffer.
elseif (vim.env.SSH_TTY and vim.env.SSH_TTY ~= "")
    or (vim.env.DISPLAY or "") == "" and (vim.env.WAYLAND_DISPLAY or "") == "" then
  local osc52 = require("vim.ui.clipboard.osc52")
  g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end

if fn.has("clipboard") == 1 then
  opt.clipboard:append("unnamedplus")
end

-- ─── Wildmenu ────────────────────────────────────────────────────────────────

opt.wildcharm = vim.fn.char2nr("\t")
opt.wildignorecase = true
opt.wildignore:append({
  ".git", ".hg", ".svn", ".stversions", "*.pyc", "*.spl", "*.o", "*.out", "*~", "%*",
  "*.jpg", "*.jpeg", "*.png", "*.gif", "*.zip", "**/tmp/**", "*.DS_Store",
  "**/node_modules/**", "**/bower_modules/**", "*/.sass-cache/*",
  "__pycache__", "*.egg-info", ".pytest_cache", ".mypy_cache/**",
})

-- ─── Vim Directories ─────────────────────────────────────────────────────────

opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.swapfile = false
opt.directory = { vim.env.DATA_PATH .. "/swap/", vim.env.DATA_PATH, "~/tmp", "/var/tmp", "/tmp" }
opt.undodir = { vim.env.DATA_PATH .. "/undo/", vim.env.DATA_PATH, "~/tmp", "/var/tmp", "/tmp" }
opt.backupdir = { vim.env.DATA_PATH .. "/backup/", vim.env.DATA_PATH, "~/tmp", "/var/tmp", "/tmp" }
opt.viewdir = vim.env.DATA_PATH .. "/view/"
opt.spellfile = vim.env.VIM_PATH .. "/spell/en.utf-8.add"
opt.history = 2000
opt.shada = "!,'300,<50,@100,s10,h"

-- Disable undo for temp files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("user_persistent_undo", { clear = true }),
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
  callback = function() vim.bo.undofile = false end,
})

-- If sudo, disable swap/backup/undo/shada
if vim.env.SUDO_USER and vim.env.SUDO_USER ~= "" and vim.env.USER ~= vim.env.SUDO_USER then
  local home = vim.env.HOME or ""
  local user_home = fn.expand("~" .. vim.env.USER)
  local sudo_home = fn.expand("~" .. vim.env.SUDO_USER)
  if home ~= user_home and home == sudo_home then
    opt.swapfile = false
    opt.backup = false
    opt.undofile = false
    opt.shada = "NONE"
  end
end

-- Secure sensitive info
opt.backupskip:append({ "/tmp/*", "$TMPDIR/*", "$TMP/*", "$TEMP/*", "*/shm/*", "/private/var/*", ".vault.vim" })

-- Disable swap/undo in temp directories
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPre" }, {
  group = vim.api.nvim_create_augroup("user_secure", { clear = true }),
  pattern = { "/tmp/*", "$TMPDIR/*", "$TMP/*", "$TEMP/*", "*/shm/*", "/private/var/*", ".vault.vim" },
  callback = function()
    vim.bo.swapfile = false
    vim.bo.undofile = false
    vim.opt_local.backup = false
    vim.opt_local.writebackup = false
  end,
})

-- ─── Tabs and Indents ────────────────────────────────────────────────────────

opt.textwidth = 140
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = -1
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true
opt.breakindentopt = { "shift:2", "min:20", "list:-1" }

-- ─── Timing ──────────────────────────────────────────────────────────────────

opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500

-- ─── Searching ───────────────────────────────────────────────────────────────

opt.ignorecase = true
opt.smartcase = true
opt.infercase = true
opt.incsearch = true
opt.wrapscan = false
opt.hlsearch = true
opt.complete = { ".", "w", "b", "k" }

if fn.executable("rg") == 1 then
  opt.grepformat = "%f:%l:%m"
  opt.grepprg = "rg --vimgrep" .. (vim.o.smartcase and " --smart-case" or "")
elseif fn.executable("ag") == 1 then
  opt.grepformat = "%f:%l:%m"
  opt.grepprg = "ag --vimgrep" .. (vim.o.smartcase and " --smart-case" or "")
end

-- ─── Behavior ────────────────────────────────────────────────────────────────

opt.autoread = true
opt.wrap = false
opt.linebreak = true
opt.breakat = "  ;:,!?"
opt.startofline = false
opt.whichwrap:append("h,l,<,>,[,],~")
opt.splitbelow = true
opt.splitright = true
opt.switchbuf = { "useopen", "uselast" }
opt.backspace = { "indent", "eol", "start" }
opt.diffopt = { "filler", "iwhite", "internal", "algorithm:patience" }
opt.completeopt = { "menu", "menuone", "noinsert" }
opt.jumpoptions = "stack"

-- ─── Editor UI ───────────────────────────────────────────────────────────────

opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.ruler = false
opt.shortmess = "aoOTI"
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
  vert = "│",
  diff = "╱",
}
opt.list = true
opt.showbreak = "↳  "

if g.low_performance_mode then
  opt.listchars = { tab = "│ ", extends = "⟫", precedes = "⟪", nbsp = "␣", trail = "·" }
else
  opt.listchars = { tab = "»·", extends = "⟫", precedes = "⟪", nbsp = "␣", trail = "·" }
end

opt.title = true
opt.titlelen = 95
opt.titlestring = "%{expand('%:p:~:.')}%(%m%r%w%) %<[%{fnamemodify(getcwd(), ':~')}] - Neovim"

opt.showmatch = true
opt.matchpairs:append("<:>")
opt.matchtime = 1
opt.showtabline = 2
opt.pumheight = 15
opt.helpheight = 12
opt.previewheight = 12
opt.showcmd = true
opt.cmdheight = 2
opt.cmdwinheight = 5
opt.equalalways = false
opt.laststatus = 2
opt.colorcolumn = { "+1", "+2" }
opt.display = "lastline"
opt.cursorline = true

-- Folding
opt.foldenable = true
opt.foldmethod = "syntax"
opt.foldlevelstart = 99

-- Conceal
opt.conceallevel = 2
opt.concealcursor = "c"

-- Pseudo-transparency
if vim.o.termguicolors then
  opt.pumblend = 10
  opt.winblend = 10
end

-- ─── Neovide / GUI ──────────────────────────────────────────────────────────

if g.neovide or vim.fn.exists("g:Gui") == 1 or vim.fn.exists("g:GuiLoaded") == 1 then
  -- Font size adjustment
  vim.api.nvim_create_user_command("FontSizeUp", function()
    g.guifontsize = (g.guifontsize or 14) + 1
    opt.guifont = g.guifont .. ":h" .. g.guifontsize
  end, {})
  vim.api.nvim_create_user_command("FontSizeDown", function()
    g.guifontsize = (g.guifontsize or 14) - 1
    opt.guifont = g.guifont .. ":h" .. g.guifontsize
  end, {})

  vim.keymap.set("n", "<C-ScrollWheelUp>", "<cmd>FontSizeUp<CR>", { silent = true })
  vim.keymap.set("n", "<C-ScrollWheelDown>", "<cmd>FontSizeDown<CR>", { silent = true })
  vim.keymap.set("i", "<C-ScrollWheelUp>", "<Esc><cmd>FontSizeUp<CR>a", { silent = true })
  vim.keymap.set("i", "<C-ScrollWheelDown>", "<Esc><cmd>FontSizeDown<CR>a", { silent = true })

  opt.guifont = (g.guifont or "monospace") .. ":h" .. (g.guifontsize or 14)
end

if g.neovide then
  -- General
  g.neovide_remember_window_size = true
  g.neovide_profiler = false
  g.neovide_theme = "auto"

  -- Animation
  g.neovide_cursor_vfx_mode = "ripple"
  g.neovide_scroll_animation_length = 0.25
  g.neovide_hide_mouse_when_typing = true
  g.neovide_cursor_trail_size = 0.8
  g.neovide_refresh_rate = 60
  g.neovide_cursor_smooth_blink = false

  -- Floating window
  g.neovide_float_blur = true
  g.neovide_floating_opacity = 0.7
  g.neovide_floating_shadow = true
  g.neovide_floating_z_height = 10
  g.neovide_floating_blur_amount_x = 5.0
  g.neovide_floating_blur_amount_y = 5.0
  g.neovide_light_angle_degrees = 45
  g.neovide_light_radius = 5

  -- Background Transparency (macOS only)
  g.neovide_opacity = 0.2
  g.neovide_opacity_point = 0.3
  g.neovide_background_color = "#0f1117" .. string.format("%x", math.floor(255 * 0.3))
  g.neovide_window_blurred = true

  -- Scale factor
  g.neovide_scale_factor = 1.0
  vim.keymap.set("n", "<C-=>", function()
    g.neovide_scale_factor = g.neovide_scale_factor * 1.25
  end)
  vim.keymap.set("n", "<C-->", function()
    g.neovide_scale_factor = g.neovide_scale_factor / 1.25
  end)

  -- Transparency adjustment (macOS)
  vim.keymap.set("n", "<D-]>", function()
    g.neovide_opacity_point = g.neovide_opacity_point + 0.01
    g.neovide_background_color = "#0f1117" .. string.format("%x", math.floor(255 * g.neovide_opacity_point))
  end)
  vim.keymap.set("n", "<D-[>", function()
    g.neovide_opacity_point = g.neovide_opacity_point - 0.01
    g.neovide_background_color = "#0f1117" .. string.format("%x", math.floor(255 * g.neovide_opacity_point))
  end)

  g.neovide_input_use_logo = 1

  -- Copy/paste in neovide
  vim.keymap.set({ "n", "v" }, "<C-S-v>", '"+p', { silent = true })
  vim.keymap.set({ "i", "c" }, "<C-S-v>", "<C-R>+", { silent = true })
  vim.keymap.set("t", "<C-S-v>", "<C-R>+", { silent = true })
  vim.keymap.set("v", "<C-S-c>", '"+y', { silent = true })
  vim.keymap.set("n", "<D-s>", "<cmd>w<CR>", { silent = true })
  vim.keymap.set("v", "<D-c>", '"+y', { silent = true })
  vim.keymap.set("n", "<D-v>", '"+P', { silent = true })
  vim.keymap.set("v", "<D-v>", '"+P', { silent = true })
  vim.keymap.set("c", "<D-v>", "<C-R>+", { silent = true })
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli', { silent = true })
end
