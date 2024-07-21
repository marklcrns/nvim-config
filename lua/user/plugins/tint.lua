return function()
  require("tint").setup({
    tint_background_colors = true,  -- Tint background portions of highlight groups
    transforms = {
      require("tint.transforms").tint_with_threshold(-100, "#1C1C1C", 200), -- Try to tint by `-100`, but keep all colors at least `150` away from `#1C1C1C`
      require("tint.transforms").saturate(0.5),
    },
    highlight_ignore_patterns = { "WinSeparator", "Status.*" },  -- Highlight group patterns to ignore, see `string.find`
    window_ignore_function = function(winid)
      local bufid = vim.api.nvim_win_get_buf(winid)
      local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
      local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

      -- Do not tint `terminal` or floating windows, tint everything else
      return buftype == "terminal" or floating
    end
  })
end
