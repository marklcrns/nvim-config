  return function()
    require("mini.files").setup({
      -- Options for the file explorer
      options = {
        show_hidden = true,  -- Show hidden files
        follow_symlinks = true,  -- Follow symbolic links
        sort_by = "name",  -- Sort files by name
        width = 30,  -- Width of the file explorer window
        -- Disabled by default in LazyVim because neo-tree is used for that
        use_as_default_explorer = false,
      },
      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = 'L',
        go_out      = 'h',
        go_out_plus = 'H',
        mark_goto   = "'",
        mark_set    = 'm',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
      },
      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = false,
        -- Width of focused window
        width_focus = 30,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 30,
      },
    })
end
