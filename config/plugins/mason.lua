require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  -- Installation directory. Usually in ~/.local/share/nvim
  -- See :lua print(vim.fn.stdpath("data"))
  install_root_dir = vim.fn.stdpath("data") .. "/mason",
})
