local M = {}

function M.is_windows()
  return vim.loop.os_uname().sysname == "Windows_NT"
end

-- Memoized: spawns `uname -r` once, result is constant for the session.
local _is_wsl
function M.is_wsl()
  if _is_wsl == nil then
    local output = vim.fn.systemlist("uname -r")
    _is_wsl = not not string.find(output[1] or "", "WSL")
  end
  return _is_wsl
end

function M.is_mac()
  return vim.fn.has("macunix") == 1
end

function M.is_linux()
  return not M.is_windows() and not M.is_wsl() and not M.is_mac()
end

-- Memoized: spawns `whoami` once, username is constant for the session.
local _whoami
function M.whoami()
  if _whoami == nil then
    -- Prefer env vars (no subprocess) and fall back to whoami only if unset.
    _whoami = vim.env.USER or vim.env.USERNAME or vim.fn.systemlist("whoami")[1] or ""
  end
  return _whoami
end

function M.is_gui()
  local has = vim.fn.has
  local exists = vim.fn.exists
  return exists("g:vscode") == 1
    or exists("g:neovide") == 1
    or exists("g:Gui") == 1
    or exists("g:GuiLoaded") == 1
    or has("gui_running") == 1
    or has("gui") == 1
end

function M.is_firenvim()
  return vim.g.started_by_firenvim
end

-- Amazon work laptop username
function M.is_amazon()
  return M.whoami() == "mrklcrns"
end

return M
