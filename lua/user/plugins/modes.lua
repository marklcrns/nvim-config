return function()
  require("modes").setup({
    colors = {
      -- copy = "#edb000",
      -- delete = "#D30044",
      -- insert = "#731da2",
      -- visual = "#78ccc5",
      copy = "#ffffa3",
      delete = "#ef909e",
      insert = "#d583fc",
      visual = "#e2ffff",
    },

    -- Set opacity for cursorline and number background
    line_opacity = 0.20,

    -- Enable cursor highlights
    set_cursor = false,

    -- Enable cursorline initially, and disable cursorline for inactive windows
    -- or ignored filetypes
    set_cursorline = true,

    -- Enable line number highlights to match cursorline
    set_number = true,

    -- Disable modes highlights in specified filetypes
    -- Please PR commonly ignored filetypes
    ignore_filetypes = { "NvimTree", "TelescopePrompt" },
  })
end
