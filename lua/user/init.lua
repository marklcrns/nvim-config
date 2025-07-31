local config_dir = vim.fn.stdpath("config")

-- Set up these auto commands early to ensure priority over plugins
local group = vim.api.nvim_create_augroup("colorscheme_config", {})
vim.api.nvim_create_autocmd("ColorSchemePre", {
  group = group,
  callback = function(ctx)
    require("user.colorscheme").setup_colorscheme(ctx.match)
  end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    require("user.colorscheme").apply_tweaks()
  end,
})

-- require("user.settings")
vim.cmd.source(config_dir .. "/autocommands.vim")

-- General mappings
require("user.core.utils").load_mappings()
require("user.core")

require("user.plugins")
-- NOTE: Temporarily disabled user.commands because it loads user.async which is buggy:
-- whenever I `git checkout` to a different branch, it throws error constantly.
-- Feline also uses async. So it bugs out as well, but not too intrusively.
-- TODO: Fix this. Either remove user.async altogether or fix the errors. Try
-- uncommenting the below and `git checkout` to a different branch and see the error.
-- Also see Feline plugin configs.
require("user.commands")
require("user.colorscheme").apply()

vim.schedule(function()
  require("user.lsp")
  vim.cmd("LspStart")
end)
