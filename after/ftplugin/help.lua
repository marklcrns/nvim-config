vim.opt_local.comments:append("n:•")
vim.opt_local.formatoptions = "tnqro"
vim.opt_local.iskeyword = [[!-~,^*,^\|,^",192-255]]

-- Send all helptags to loclist
vim.keymap.set("n", "<M-o>", [[<Cmd>lvimgrep /\v.*\*\S+\*$/j % <bar> lopen<CR>]], { buffer = true })

-- Format helptags: align tag on the right
local function format_helptags()
  local view = vim.fn.winsaveview()
  vim.cmd([[silent! %sub/\v(.{-})(\s{2,})(\*.*\*)/\=submatch(1) . repeat(" ", 48 - len(submatch(1))) . submatch(3)]])
  vim.cmd("noh")
  vim.fn.winrestview(view)
end

vim.keymap.set("n", "<leader>ff", format_helptags, { buffer = true, desc = "format helptags" })

-- Close help buffer with q if readonly
if vim.bo.readonly then
  vim.keymap.set("n", "q", "<Cmd>bd<CR>", { buffer = true })
end
