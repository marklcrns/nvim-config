return function()
  require("lint").setup({
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
  })
end
