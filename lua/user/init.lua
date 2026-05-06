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
require("user.commands")
require("user.colorscheme").apply()

-- LSP init is deferred to the next event loop tick so Neovim can finish
-- drawing the UI before expensive mason/lspconfig loads. Guarded by
-- g:lsp_enabled (vimrc switch) and firenvim mode — LSP plugins are
-- excluded in firenvim sessions via `cond` in plugins/init.lua, so
-- requiring user.lsp there would crash on missing jdtls/typescript-tools.
if vim.g.lsp_enabled ~= false and not vim.g.started_by_firenvim then
  vim.schedule(function()
    require("user.lsp")
  end)
end
