vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  char_highlight_list = {
      "IndentBlanklineIndent1",
      "IndentBlanklineIndent2",
      "IndentBlanklineIndent3",
      "IndentBlanklineIndent4",
      "IndentBlanklineIndent5",
  },
}

vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_filetype_exclude = {
  'help', 'man', 'fern', 'defx', 'denite', 'denite-filter', 'startify',
  'vista', 'vista_kind', 'tagbar', 'lsp-hover', 'clap_input', 'fzf',
  'any-jump', 'gina-status', 'gina-commit', 'gina-log', 'minimap',
  'quickpick-filter', 'lsp-quickpick-filter', 'calendar', 'coc-explorer',
  'dashboard', 'codi', 'which_key', 'taskreport', 'floaterm'
}
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_space_char_blankline = " "
vim.g.indent_blankline_strict_tabs = true
vim.g.indent_blankline_debug = true
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
  "class",
  "function",
  "method",
  "^if",
  "while",
  "for",
  "with",
  "func_literal",
  "block",
  "try",
  "except",
  "argument_list",
  "object",
  "dictionary"
}
