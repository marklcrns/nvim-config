return function()
  require("obsidian").setup({
    workspaces = {
      {
        name = "personal",
        path = "/mnt/c/Users/markl/obsidian/personal",
      },
    },
    ui = {
      enable = false,
    }
  })
end
