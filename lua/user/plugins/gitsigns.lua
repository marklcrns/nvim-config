return function ()
  local hi_link = Config.common.hl.hi_link

  require("gitsigns").setup {
    -- debug_mode = true,
    signs = {
      add = { text = "▍" },
      change = { text = "▍" },
      delete = { text = "▍" },
      changedelete = { text = "▍" },
      topdelete = { text = "‾" },
    },
    signs_staged = {
      add = { text = "▍" },
      change = { text = "▍" },
      delete = { text = "▍" },
      changedelete = { text = "▍" },
      topdelete = { text = "‾" },
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
    sign_priority = 1000,
    update_debounce = 100,
    status_formatter = nil, -- Use default
  }

  hi_link("GitSignsAdd", "diffAdded", { default = true })
  hi_link("GitSignsChange", "diffChanged", { default = true })
  hi_link("GitSignsDelete", "diffRemoved", { default = true })
end
