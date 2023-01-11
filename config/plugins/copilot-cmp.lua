require("copilot_cmp").setup({
  method = "getCompletionsCycling",
  formatters = {
    insert_text = require("copilot_cmp.format").remove_existing,
  },
})
