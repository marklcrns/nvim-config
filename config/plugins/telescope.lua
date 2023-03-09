require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

    winblend = 20,
    width = 0.8,
    show_line = false,
    prompt_prefix = "🔍 ",
    prompt_title = "",
    results_title = "",
    preview_title = "",
    borderchars = {
      prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      results = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
      preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
    },

    -- winblend = 0,
    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    -- prompt_prefix = "> ",
    selection_caret = "> ",

    border = {},
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
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
