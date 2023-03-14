local M = {}

function M.is_wsl()
  local output = vim.fn.systemlist("uname -r")
  return not not string.find(output[1] or "", "WSL")
end

function M.is_mac()
  return vim.fn.has("macunix") == 1
end

function M.is_linux()
  return not M.is_wsl() and not M.is_mac()
end

return M
