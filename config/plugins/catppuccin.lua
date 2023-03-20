require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "macchiato",
  },
  transparent_background = vim.api.nvim_get_var("transparent_background"),
  show_end_of_buffer = false, -- show the '~' characters after the end of buffers
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.00,
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  -- Telescope borderless theme
  custom_highlights = function(c)
    local prompt = "#2c3048"
    local bg = "#1e2030"
    return {
      TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      },
      TelescopeBorder = {
        bg = bg,
        fg = bg,
      },
      TelescopePromptNormal = {
        bg = prompt,
      },
      TelescopePromptBorder = {
        bg = prompt,
        fg = prompt,
      },
      TelescopePromptTitle = {
        bg = prompt,
        fg = prompt,
      },
      TelescopePreviewTitle = {
        bg = bg,
        fg = bg,
      },
      TelescopeResultsTitle = {
        bg = bg,
        fg = bg,
      },
    }
  end,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,
    notify = false,
    mini = false,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})
