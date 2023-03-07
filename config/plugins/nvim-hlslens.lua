require("hlslens").setup({
  override_lens = function(render, posList, nearest, idx, relIdx)
    local sfw = vim.v.searchforward == 1
    local indicator, text, chunks
    local absRelIdx = math.abs(relIdx)
    if absRelIdx > 1 then
      indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
    elseif absRelIdx == 1 then
      indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
    else
      indicator = ""
    end

    local lnum, col = unpack(posList[idx])
    if nearest then
      local cnt = #posList
      if indicator ~= "" then
        text = ("[%s %d/%d]"):format(indicator, idx, cnt)
      else
        text = ("[%d/%d]"):format(idx, cnt)
      end
      chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
    else
      text = ("[%s %d]"):format(indicator, idx)
      chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
    end
    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
  end,
})

local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap(
  "n",
  "n",
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts
)
vim.api.nvim_set_keymap(
  "n",
  "N",
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts
)
vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)

-- nvim-ufo integration
local function nN(char)
  local ok, winid = require("hlslens").nNPeekWithUFO(char)
  if ok and winid then
    -- Safe to override buffer scope keymaps remapped by ufo,
    -- ufo will restore previous buffer keymaps before closing preview window
    -- Type <CR> will switch to preview window and fire `trace` action
    vim.keymap.set("n", "<CR>", function()
      local keyCodes = vim.api.nvim_replace_termcodes("<Tab><CR>", true, false, true)
      vim.api.nvim_feedkeys(keyCodes, "im", false)
    end, { buffer = true })
  end
end

vim.keymap.set({ "n", "x" }, "n", function()
  nN("n")
end)
vim.keymap.set({ "n", "x" }, "N", function()
  nN("N")
end)
