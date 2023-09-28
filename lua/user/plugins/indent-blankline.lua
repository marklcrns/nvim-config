return function()
  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }
  local hooks = require("ibl.hooks")
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  vim.g.rainbow_delimiters = { highlight = highlight }

  require("ibl").setup({
    char = "▏",
    context_char = "▏",
    -- space_char = " ",
    space_char_blankline = "⠀",
    use_treesitter = false,
    use_treesitter_scope = false,
    show_trailing_blankline_indent = false,
    show_current_context = true,
    max_indent_increase = 2,
    buftype_exclude = {
      "terminal",
      "nofile",
    },
    scope = { highlight = highlight },
    filetype_exclude = {
      "DiffviewFileHistory",
      "DiffviewFiles",
      "LspSagaCodeAction",
      "NeogitCommitMessage",
      "NeogitCommitView",
      "NeogitLogView",
      "NeogitPopup",
      "NeogitStatus",
      "NvimTree",
      "Outline",
      "TelescopePrompt",
      "Trouble",
      "alpha",
      "any-jump",
      "calendar",
      "clap_input",
      "coc-explorer",
      "codi",
      "dashboard",
      "defx",
      "denite",
      "denite-filter",
      "fern",
      "floaterm",
      "fugitive",
      "fzf",
      "gina-commit",
      "gina-log",
      "gina-status",
      "help",
      "help",
      "lsp-hover",
      "lsp-quickpick-filter",
      "lspinfo",
      "lspsagafinder",
      "man",
      "minimap",
      "norg",
      "packer",
      "quickpick-filter",
      "sagahover",
      "sagasignature",
      "startify",
      "tagbar",
      "taskreport",
      "vista",
      "vista_kind",
      "which_key",
    },
  })

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end
