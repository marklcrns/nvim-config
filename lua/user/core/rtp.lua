-- Port of core/rtp.vim — path setup and directory creation

local fn = vim.fn

-- Set main configuration directory
vim.env.VIM_PATH = fn.stdpath("config")
-- Set data/cache directory as $XDG_CACHE_HOME/vim
vim.env.DATA_PATH = fn.expand((vim.env.XDG_CACHE_HOME or "~/.cache") .. "/vim")
-- Set sync directory
vim.env.SYNC_PATH = fn.expand(vim.env.HOME .. "/Sync/cache/vim")

-- Ensure data directories exist
local dirs = {
  vim.env.DATA_PATH,
  vim.env.SYNC_PATH,
  vim.env.DATA_PATH .. "/undo",
  vim.env.DATA_PATH .. "/backup",
  vim.env.DATA_PATH .. "/session",
  vim.env.SYNC_PATH .. "/session",
  vim.env.VIM_PATH .. "/spell",
}

for _, dir in ipairs(dirs) do
  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, "p", tonumber("0770", 8))
  end
end
