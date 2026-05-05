return function()
  require("marks").setup({
    -- Whether to map keybinds or not. Default true.
    default_mappings = true,
    -- Which builtin marks to show (see :h marks). Default {}.
    builtin_marks = { ".", "<", ">", "^" },
    -- Whether movements cycle back to the beginning/end of buffer. Default true.
    cycle = true,
    -- Disable output of deletion messages from vim commands.
    force_write_shada = false,
    -- How often (in ms) to redraw signs/recompute mark positions.
    refresh_interval = 250,
    -- Sign priorities for each type of mark — builtin marks, uppercase marks,
    -- lowercase marks, bookmarks, lower priority = higher sign priority.
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    -- Marks to exclude (e.g., `abc` disables bookmarks a/b/c).
    excluded_filetypes = {
      "alpha", "dashboard", "lazy", "mason", "neo-tree", "TelescopePrompt",
      "TelescopeResults", "help", "qf", "terminal", "toggleterm",
    },
    excluded_buftypes = { "nofile", "terminal" },
    -- Marker sign character for bookmarks (4 bookmark groups available).
    bookmark_0 = {
      sign = "⚑",
      virt_text = "hello world",
      annotate = false,
    },
    mappings = {
      -- Default mappings closely match vim-signature:
      --   m<letter>  set mark
      --   m,         set next available lowercase mark
      --   m;         toggle mark at current line
      --   dm<letter> delete mark
      --   dm-        delete all marks on current line
      --   dm<space>  delete all marks in buffer
      --   m]         next mark
      --   m[         previous mark
      -- (We leave defaults on — this block is for future overrides.)
    },
  })
end
