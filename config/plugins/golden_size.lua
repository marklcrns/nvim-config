-- Off by default
vim.api.nvim_set_var("golden_size_off", 1)

function GoldenSizeToggle()
  local current_value = vim.api.nvim_get_var("golden_size_off")
  vim.api.nvim_set_var("golden_size_off", current_value == 1 and 0 or 1)
end

local function golden_size_ignore()
  return vim.api.nvim_get_var("golden_size_off")
end

-- Ignore by buffer type
local function ignore_by_buftype(types)
  local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
  for _, type in pairs(types) do
    if type == buftype then
      return 1
    end
  end
end

-- Ignore by filetype
local function ignore_by_filetype(types)
  local filetype = vim.bo.filetype
  for _, type in pairs(types) do
    if type == filetype then
      return 1
    end
  end
end

local golden_size = require("golden_size")
-- set the callbacks, preserve the defaults
golden_size.set_ignore_callbacks({
  { golden_size_ignore },
  { golden_size.ignore_float_windows }, -- default one, ignore float windows
  { golden_size.ignore_by_window_flag }, -- default one, ignore windows with w:ignore_gold_size=1
  { ignore_by_filetype, {'vista', 'fern', 'NvimTree', 'Mundo', 'MundoDiff', 'minimap', 'fugitive', 'gitcommit', 'qf', 'list'} },
  { ignore_by_buftype, {'terminal', 'quickfix', 'nerdtree'} }
})
