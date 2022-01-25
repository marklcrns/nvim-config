require('kommentary.config').configure_language("default", {
  prefer_single_line_comments = true,
  ignore_whitespace = true,
  use_consistent_indentation = true,
})

require('kommentary.config').configure_language("rust", {
  single_line_comment_string = "//",
  multi_line_comment_strings = {"/*", "*/"},
})
