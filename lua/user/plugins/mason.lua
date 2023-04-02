return function()
  require("mason").setup({
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ﮊ",
      },

      keymaps = {
        toggle_server_expand = "<CR>",
        install_server = "i",
        update_server = "u",
        check_server_version = "c",
        update_all_servers = "U",
        check_outdated_servers = "C",
        uninstall_server = "X",
        cancel_installation = "<C-c>",
      },
    },

    max_concurrent_installers = 10,
    -- Installation directory. Usually in ~/.local/share/nvim
    -- See :lua print(vim.fn.stdpath("data"))
    -- install_root_dir = vim.fn.stdpath("data") .. "/mason",
  })
end
