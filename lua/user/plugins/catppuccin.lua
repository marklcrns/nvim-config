return function()
  require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "latte",
      dark = "macchiato",
    },
    transparent_background = vim.g.transparent_enabled,
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
          bg = bg,
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
      notify = true,
      indent_blankline = {
        enabled = true,
        scope_color = "lavander", -- catppuccin color (eg. `lavender`) Default: text
        colored_indent_levels = true,
      },
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
  })

  -- Ref: https://github.com/89iuv/dotfiles/blob/master/nvim/lua/plugins/configs/catppuccin.lua
  local base1 = "#2D3145"
  local colors = require("catppuccin.palettes").get_palette()
  require("catppuccin.lib.highlighter").syntax({
    -- MsgArea = { bg = colors.mantle },
    NormalFloat = { bg = base1 },
    CursorLine = { bg = colors.surface0 },
    -- PmenuSel = { fg = colors.mantle, bg = colors.blue },
    -- FloatBorder = { fg = colors.surface0, bg = colors.surface0 },
  })
end
