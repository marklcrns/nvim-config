return function()
  local sep = require("plenary.path").path.sep
  require("leetbuddy").setup({
    domain = "com", -- `cn` for chinese leetcode
    directory = vim.loop.os_homedir() .. sep .. "Sync" .. sep .. "dev" .. sep .. "leetcode",
    language = "py",
  })
end
