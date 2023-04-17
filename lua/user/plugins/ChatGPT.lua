return function()
  require("chatgpt").setup({
    chat = {
      keymaps = {
        close = { "<C-c>", "<Esc>" },
      },
    },
    popup_input = {
      submit = "<M-Enter>",
    },
  })
end
