local opt = vim.opt

local function list(value, str, sep)
  sep = sep or ","
  str = str or ""
  value = type(value) == "table" and table.concat(value, sep) or value
  return str ~= "" and table.concat({ value, str }, sep) or value
end

opt.magic = true
opt.number = true
opt.relativenumber = true
opt.autoindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = -1
opt.expandtab = true
opt.textwidth = 80
opt.smarttab = true
opt.smartindent = true
opt.shiftround = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignorecase = true
opt.showcmd = true
opt.splitbelow = true
opt.splitright = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.backspace = list({ "indent", "eol", "start" })
opt.inccommand = "split"
opt.foldmethod = "expr"
opt.foldlevelstart = 99
opt.scrolloff = 3
opt.virtualedit = list({ "block" })
opt.signcolumn = "yes:2"
opt.colorcolumn = list({ "100" })
opt.list = true
opt.listchars = list({
  "tab: ──",
  "lead:·",
  "trail:•",
  "nbsp:␣",
  -- "eol:↵",
  "precedes:«",
  "extends:»",
})
opt.fillchars = list({
  -- "vert:▏",
  "vert:│",
  "diff:╱",
  "foldclose:",
  "foldopen:",
  "fold: ",
  "msgsep:─",
})
opt.showbreak = "⤷ "
opt.laststatus = 2

vim.cmd([[
  if has('mac')
    let g:clipboard = {
          \   'name': 'macOS-clipboard',
          \   'copy': {
          \      '+': 'pbcopy',
          \      '*': 'pbcopy',
          \    },
          \   'paste': {
          \      '+': 'pbpaste',
          \      '*': 'pbpaste',
          \   },
          \   'cache_enabled': 0,
          \ }
  endif

  if has('clipboard')
    set clipboard& clipboard+=unnamedplus
  endif
]])

