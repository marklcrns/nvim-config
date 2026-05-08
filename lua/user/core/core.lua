-- Port of core/core.vim — distribution plugin disabling, python host, termguicolors

local fn = vim.fn

-- Disable vim distribution plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

-- Session directory
vim.g.session_directory = vim.env.SYNC_PATH .. "/session"

-- Python interpreter settings (from dedicated virtualenv)
local python = vim.env.DATA_PATH .. "/venv/python/env/bin/python"
local python3 = vim.env.DATA_PATH .. "/venv/python3/env/bin/python3"
if fn.filereadable(python) == 1 then
  vim.g.python_host_prog = python
end
if fn.filereadable(python3) == 1 then
  vim.g.python3_host_prog = python3
end

-- Enable 24-bit RGB color
if vim.env.COLORTERM == "" or (vim.env.COLORTERM or ""):match("truecolor") or (vim.env.COLORTERM or ""):match("24bit") then
  vim.o.termguicolors = true
end

-- Load general settings
require("user.core.general")

-- Phase 1 mappings (ported from core/mappings.vim)
require("user.core.mappings_vim")

-- Source mappings.vim (kept in vimscript — remaining phases)
vim.cmd.source(vim.env.VIM_PATH .. "/core/mappings.vim")

vim.o.secure = true
