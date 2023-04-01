return function()
  require("indent_blankline").setup({
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
end
