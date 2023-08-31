return function()
  require("codewindow").setup({
    active_in_terminals = false, -- Should the minimap activate for terminal buffers
    auto_enable = false, -- Automatically open the minimap when entering a (non-excluded) buffer (accepts a table of filetypes)
    exclude_filetypes = { "help" }, -- Choose certain filetypes to not show minimap on
    max_minimap_height = nil, -- The maximum height the minimap can take (including borders)
    max_lines = nil, -- If auto_enable is true, don't open the minimap for buffers which have more than this many lines.
    minimap_width = 15, -- The width of the text part of the minimap
    use_lsp = true, -- Use the builtin LSP to show errors and warnings
    use_treesitter = true, -- Use nvim-treesitter to highlight the code
    use_git = true, -- Show small dots to indicate git additions and deletions
    width_multiplier = 4, -- How many characters one dot represents
    z_index = 1, -- The z-index the floating window will be on
    show_cursor = true, -- Show the cursor position in the minimap
    screen_bounds = "background", -- How the visible area is displayed, "lines": lines above and below, "background": background color
    window_border = "none", -- The border style of the floating window (accepts all usual options)
    relative = "win", -- What will be the minimap be placed relative to, "win": the current window, "editor": the entire editor
    events = { "TextChanged", "InsertLeave", "DiagnosticChanged", "FileWritePost" }, -- Events that update the code window
  })
end
