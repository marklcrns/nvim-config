require("copilot_cmp").setup({
  method = "getCompletionsCycling",
  formatters = {
    label = require("copilot_cmp.format").format_label_text,
    -- insert_text = require("copilot_cmp.format").format_insert_text,
    -- Experimental fix to remove extraneous characters such as extra ending parenthesis
    insert_text = require("copilot_cmp.format").remove_existing,
    preview = require("copilot_cmp.format").deindent,
  },
})
