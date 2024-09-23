return function()
  local leap = require("leap")
  leap.add_default_mappings()
  leap.opts.case_sensitive = true
  leap.opts.safe_labels = {}

  vim.keymap.set({'n', 'o'}, 'gs', function ()
    require('leap.remote').action()
  end)
end
