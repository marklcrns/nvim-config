return function()
  local hi_link = Config.common.hl.hi_link

  require("gitsigns").setup({
    -- debug_mode = true,
    signs = {
      add = {
        text = "▍",
        -- hl = "GitSignsAdd",
        -- numhl = "GitSignsAddNr",
        -- linehl = "GitSignsAddLn",
      },
      change = {
        text = "▍",
        -- hl = "GitSignsChange",
        -- numhl = "GitSignsChangeNr",
        -- linehl = "GitSignsChangeLn",
      },
      delete = {
        text = "▍",
        -- hl = "GitSignsDelete",
        -- numhl = "GitSignsDeleteNr",
        -- linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        text = "▍",
        -- hl = "GitSignsChange",
        -- numhl = "GitSignsChangeNr",
        -- linehl = "GitSignsChangeLn",
      },
      topdelete = {
        text = "‾",
        -- hl = "GitSignsDelete",
        -- numhl = "GitSignsDeleteNr",
        -- linehl = "GitSignsDeleteLn",
      },
    },
    numhl = false,
    linehl = false,
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    diff_opts = {
      algorithm = "histogram",
      internal = true,
      indent_heuristic = true,
    },
    sign_priority = 100,
    update_debounce = 100,
    status_formatter = nil, -- Use default
  })

  -- Diff highlights integration
  hi_link("GitSignsAdd", "diffAdded", { default = true })
  hi_link("GitSignsChange", "diffChanged", { default = true })
  hi_link("GitSignsDelete", "diffRemoved", { default = true })
end
