local M = {}

function M.is_windows()
  return vim.loop.os_uname().sysname == "Windows_NT"
end

function M.is_wsl()
  local output = vim.fn.systemlist("uname -r")
  return not not string.find(output[1] or "", "WSL")
end

function M.is_mac()
  return vim.fn.has("macunix") == 1
end

function M.is_linux()
  return not M.is_windows() and not M.is_wsl() and not M.is_mac()
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

return M
