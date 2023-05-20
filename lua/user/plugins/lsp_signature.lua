return function()
  require("lsp_signature").setup({
    floating_window = true,
    hint_enable = false,
    hint_prefix = "● ",
    max_width = 80,
    max_height = 12,
    handler_opts = {
      border = "single",
    },
    timer_interval = 200,
  })
end
