return function()
  require("treesitter-context").setup({
    max_lines = 2,
    zindex = 1,
    trim_scope = "inner",
    multiline_threshold = 300,
  })
end
