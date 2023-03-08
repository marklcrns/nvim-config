NvimConfigDir = vim.fn.stdpath("config")

vim.cmd("source " .. NvimConfigDir .. "/vimrc")
require("user.common")
