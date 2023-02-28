require("nvim-treesitter.configs").setup({
  textsubjects = {
    enable = true,
    prev_selection = ";", -- (Optional) keymap to select the previous selection
    keymaps = {
      ["<cr>"] = "textsubjects-smart",
    },
  },
})
