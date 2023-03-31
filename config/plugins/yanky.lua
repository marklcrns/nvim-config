require("yanky").setup({
  ring = {
    history_length = 1000,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
  },
  picker = {
    select = {
      action = nil, -- nil to use default put action
    },
    telescope = {
      mappings = nil, -- nil to use default mappings
    },
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 300,
  },
  preserve_cursor_position = {
    enabled = true,
  },
})

require("telescope").load_extension("yank_history")
