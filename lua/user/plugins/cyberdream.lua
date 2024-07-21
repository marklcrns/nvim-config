return function()
  require("cyberdream").setup({
    -- Enable transparent background
    transparent = vim.g.transparent_enabled,
    -- Enable italics comments
    italic_comments = true,
    -- Replace all fillchars with ' ' for the ultimate clean look
    hide_fillchars = true,
    -- Modern borderless telescope theme
    borderless_telescope = true,
    -- Set terminal colors used in `:terminal`
    terminal_colors = true,
    theme = {
      variant = "auto", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
    },
    -- Disable or enable colorscheme extensions
    extensions = {
      telescope = true,
      notify = true,
    },
  })
end
