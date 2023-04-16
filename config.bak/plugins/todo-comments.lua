require("todo-comments").setup({
  signs = false, -- show icons in the signs column
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    multiline = true, -- enable multine todo comments
    multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
})

-- FIX: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- FIXME: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- BUG: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- FIXIT: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- ISSUE: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.

-- TODO: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.

-- HACK: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- WARN: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- WARNING: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- XXX: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.

-- PERF: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- OPTIM: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- PERFORMANCE: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- OPTIMIZE: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.

-- NOTE: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- INFO: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.

-- TEST: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- TESTING: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- PASSED: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
-- FAILED: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
-- nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed.
