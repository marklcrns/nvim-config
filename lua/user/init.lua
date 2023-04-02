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

vim.cmd("source " .. config_dir .. "/vimrc")
vim.cmd("source " .. config_dir .. "/autocommands.vim")

require("user.core.utils").load_mappings()

vim.env.PATH = vim.env.PATH .. (Config.common.sys.is_windows() and ";" or ":") .. vim.fn.stdpath("data") .. "/mason/bin"

require("user.core")
require("user.plugins")

require("user.colorscheme").apply()

vim.schedule(function()
  require("user.lsp")
  vim.cmd("LspStart")
end)
