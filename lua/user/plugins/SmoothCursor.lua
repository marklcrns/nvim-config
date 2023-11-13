return function()
  require("smoothcursor").setup({
    type = "exp", -- define cursor movement calculate function, "default" or "exp" (exponential).
    autostart = true,
    cursor = "", -- cursor shape (need nerd font)
    texthl = "SmoothCursor", -- highlight group, default is { bg = nil, fg = "#FFD400" }
    linehl = nil, -- highlight sub-cursor line like 'cursorline', "CursorLine" recommended
    fancy = {
      enable = true, -- enable fancy mode
      head = { cursor = "󱥒", texthl = "SmoothCursorGreen0", linehl = nil },
      -- NOTE: highlights defined in lua/user/colorscheme.lua
      body = {
        -- 'ｱ', 'ｲ', 'ｳ', 'ｴ', 'ｵ',
        -- 'ｶ', 'ｷ', 'ｸ', 'ｹ', 'ｺ',
        -- 'ｻ', 'ｼ', 'ｽ', 'ｾ', 'ｿ',
        -- 'ﾀ', 'ﾁ', 'ﾂ', 'ﾃ', 'ﾄ',
        -- 'ﾅ', 'ﾆ', 'ﾇ', 'y', 'ﾉ',
        -- 'ﾊ', 'ﾋ', 'ﾌ', 'ﾍ', 'ﾎ',
        -- 'ﾏ', 'ﾐ', 'ﾑ', 'ﾒ', 'ﾓ',
        -- 'ﾔ', 'ﾕ', 'ﾖ',
        -- 'ﾗ', 'ﾘ', 'y', 'ﾚ', 'ﾛ',
        -- 'ﾜ', 'ｦ', 'ﾝ', '-',
        -- '1', '2', '3', '4', '5',
        -- '6', '7', '8', '9', '0',
        -- '.', '･', '=', '*', '+',
        -- '-', '>', '<',
        -- '○', 'x', '△', '□', '▽',
        { cursor = "$", texthl = "SmoothCursorGreen0" },
        { cursor = "ﾑ", texthl = "SmoothCursorGreen0" },
        { cursor = "󱌲", texthl = "SmoothCursorGreen1" },
        { cursor = "ﾔ", texthl = "SmoothCursorGreen1" },
        { cursor = "󱌱", texthl = "SmoothCursorGreen2" },
        { cursor = "ﾒ", texthl = "SmoothCursorGreen2" },
        { cursor = "0", texthl = "SmoothCursorGreen3" },
        { cursor = "ｴ", texthl = "SmoothCursorGreen3" },
        { cursor = "󰞿", texthl = "SmoothCursorGreen4" },
        { cursor = "ﾖ", texthl = "SmoothCursorGreen4" },
        { cursor = "1", texthl = "SmoothCursorGreen5" },
        { cursor = "ﾄ", texthl = "SmoothCursorGreen5" },
        { cursor = "󱌲", texthl = "SmoothCursorGreen6" },
        { cursor = "󰞼", texthl = "SmoothCursorGreen7" },
      },
      tail = { cursor = nil, texthl = "SmoothCursor" },
    },
    matrix = { -- Loaded when 'type' is set to "matrix"
      head = {
        -- Picks a random character from this list for the cursor text
        cursor = require("smoothcursor.matrix_chars"),
        -- Picks a random highlight from this list for the cursor text
        texthl = {
          "SmoothCursor",
        },
        linehl = nil, -- No line highlight for the head
      },
      body = {
        length = 6, -- Specifies the length of the cursor body
        -- Picks a random character from this list for the cursor body text
        cursor = require("smoothcursor.matrix_chars"),
        -- Picks a random highlight from this list for each segment of the cursor body
        texthl = {
          "SmoothCursorGreen",
        },
      },
      tail = {
        -- Picks a random character from this list for the cursor tail (if any)
        cursor = nil,
        -- Picks a random highlight from this list for the cursor tail
        texthl = {
          "SmoothCursor",
        },
      },
      unstop = true, -- Determines if the cursor should stop or not (false means it will stop)
    },
    flyin_effect = nil, -- "bottom" or "top"
    speed = 40, -- max is 100 to stick to your current position
    intervals = 30, -- tick interval
    priority = 10, -- set marker priority
    timeout = 3000, -- timout for animation
    threshold = 3, -- animate if threshold lines jump
    disable_float_win = true, -- disable on float window
    enabled_filetypes = nil, -- example: { "lua", "vim" }
    disabled_filetypes = nil, -- this option will be skipped if enabled_filetypes is set. example: { "TelescopePrompt", "NvimTree" }
  })
end
