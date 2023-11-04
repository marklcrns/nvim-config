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

vim.cmd.source(config_dir .. "/vimrc")
vim.cmd.source(config_dir .. "/autocommands.vim")

-- General mappings
require("user.core.utils").load_mappings()

require("user.core")
if vim.fn.exists("g:vscode") == 0 then
  require("user.plugins")
end
require("user.commands")

require("user.colorscheme").apply()

if vim.fn.exists("g:vscode") == 0 then
  vim.schedule(function()
    require("user.lsp")
    vim.cmd("LspStart")
  end)
end
