return function()
  local leap = require("leap")
  local leap_user = require("leap.user")
  local leap_remote = require("leap.remote")
  leap.add_default_mappings()
  leap.opts.case_sensitive = true
  leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

  -- Do not display label preview on first character. Only show when the second
  -- character is typed
  leap.opts.preview_filter = function () return false end

  -- Grey out the search area
  -- Or just set to grey directly, e.g. { fg = '#777777' },
  vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })

  -- Disable auto-jumping to the first match
  leap.opts.safe_labels = {}

  -- Repeat the 2-character leap, excluding the variable label (3rd character)
  leap_user.set_repeat_keys('<enter>', '<backspace>')

  -- Multi-window leap
  vim.keymap.set({'n', 'o'}, 'gs', function ()
    leap_remote.action()
  end)

  -- Multi-window leap then automatically entery blockwise visual mode on the
  -- target window and line
  vim.keymap.set({'n', 'o'}, 'gS', function ()
    leap_remote.action { input = 'V' }
  end)

  -- After multi-window leap (gs or gS) and yank (y) operator is used, when the
  -- cursor comes back it will automatically paste the yanked texts
  vim.api.nvim_create_augroup('LeapRemote', {})
  vim.api.nvim_create_autocmd('User', {
    pattern = 'RemoteOperationDone',
    group = 'LeapRemote',
    callback = function (event)
      if vim.v.operator == 'y' then
        vim.cmd('normal! p')
      end
    end,
  })
end
