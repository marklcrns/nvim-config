return function()
  require("hardtime").setup({
    max_count = 2,
    notification = false,
    disable_mouse = false,
    allow_different_key = true,
    disabled_keys = {
      ["<Up>"] = { "i" },
      ["<Down>"] = { "i" },
      ["<Left>"] = { "i" },
      ["<Right>"] = { "i" },
    },
    disabled_filetypes = {
      "qf",
      "netrw",
      "neo-tree",
      "lazy",
      "mason",
      "fugitive",
      "NeogitStatus",
      "dropbar_menu",
      "Outline",
      "floggraph",
    },
  })

  -- Enable hardtime on VimEnter
  vim.cmd([[
    augroup HardTime
      autocmd!
      autocmd VimEnter * silent! Hardtime enable
    augroup END
  ]])
end
