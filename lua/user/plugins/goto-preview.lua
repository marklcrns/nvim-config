return function()
  require("goto-preview").setup({
    width = 240,
    height = 40,
    border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}, -- Border characters of the floating windo
  })
end
