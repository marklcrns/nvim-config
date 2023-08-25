return function()
  local home = vim.fn.expand("$HOME")
  require("chatgpt").setup({
    api_key_cmd = "gpg --decrypt " .. home .. "/Documents/secret-keys/chatgpt.txt.gpg",
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
