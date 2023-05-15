return function()
  require("muren").setup({
    keys = {
      close = "q",
      toggle_side = "<Tab>",
      toggle_options_focus = "<C-s>",
      toggle_option_under_cursor = "<CR>",
      scroll_preview_up = "<C-p>",
      scroll_preview_down = "<C-n>",
      do_replace = "<CR>",
    },
  })
end
