return function()
  require("indent-o-matic").setup({
    -- Number of lines without indentation before giving up (-1 for infinite)
    max_lines = 2048,
    -- Space indentations that should be detected
    standard_widths = { 2, 4, 8 },
    -- Skip multi-line comments and strings (more accurate detection but less performant)
    skip_multiline = true,
  })
end
