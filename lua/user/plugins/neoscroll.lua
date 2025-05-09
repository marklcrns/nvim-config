return function()
  local neoscroll = require('neoscroll')
  neoscroll.setup({
    easing_function = "quadratic", -- Default easing function,
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    hide_cursor = false, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    performance_mode = false,
    -- pre_hook = nil, -- Function to run before the scrolling animation starts
    -- post_hook = nil, -- Function to run after the scrolling animation ends
    pre_hook = function()
      vim.opt.eventignore:append({
        "WinScrolled",
        "CursorMoved",
      })
    end,
    post_hook = function()
      vim.opt.eventignore:remove({
        "WinScrolled",
        "CursorMoved",
      })
    end,
  })

  -- local t = {}
  -- -- Syntax: t[keys] = {function, {function arguments}}
  -- -- Use the "sine" easing function
  -- t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "110", [['sine']] } }
  -- t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "110", [['sine']] } }
  -- -- Use the "circular" easing function
  -- t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "220", [['circular']] } }
  -- t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "220", [['circular']] } }
  -- -- Pass "nil" to disable the easing animation (constant scrolling speed)
  -- t["<C-y>"] = { "scroll", { "-0.10", "false", "50", nil } }
  -- t["<C-e>"] = { "scroll", { "0.10", "false", "50", nil } }
  -- -- When no easing function is provided the default easing function (in this case "quadratic") will be used
  -- t["zt"] = { "zt", { "200" } }
  -- t["zz"] = { "zz", { "200" } }
  -- t["zb"] = { "zb", { "200" } }
  -- require("neoscroll.config").set_mappings(t)

  local keymap = {
    -- Use the "sine" easing function
    ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 100; easing = 'sine' }) end;
    ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 100; easing = 'sine' }) end;
    -- Use the "circular" easing function
    ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 200; easing = 'circular' }) end;
    ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 200; easing = 'circular' }) end;
    -- When no value is passed the `easing` option supplied in `setup()` is used
    ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false; duration = 50 }) end;
    ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false; duration = 50 }) end;
  }
  local modes = { 'n', 'v', 'x' }
  for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
  end
end
