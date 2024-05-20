return function()
  local leetcode = require('leetcode')
  leetcode.setup({
    lang = "python3",
    storage = {
        home = "~/Sync/dev/leetcode/code/",
        cache = vim.fn.stdpath("cache") .. "/leetcode/",
    },
    keys = {
      toggle = { "q", "<ESC>" }, ---@type string|string[]
      confirm = { "<CR>" }, ---@type string|string[]

      reset_testcases = "r", ---@type string
      use_testcase = "U", ---@type string
      focus_testcases = "<M-h>", ---@type string
      focus_result = "<M-l>", ---@type string
    },
  })
end
