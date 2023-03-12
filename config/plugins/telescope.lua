require("telescope").setup({
  defaults = {
    -- winblend = 0,
    winblend = 5,
    width = 0.8,
    show_line = false,
    -- prompt_prefix = "> ",
    prompt_prefix = "🔍 ",
    prompt_title = "",
    results_title = "",
    preview_title = "",
    borderchars = {
      prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      results = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
    },
    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

    selection_caret = "> ",
  },

  pickers = {
    -- Your special builtin config goes in here
    buffers = {
      sort_lastused = true,
      previewer = true,
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
      },
    },
  },
})
