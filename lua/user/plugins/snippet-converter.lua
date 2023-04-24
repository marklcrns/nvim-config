return function()
  local template = {
    -- name = "t1", (optionally give your template a name to refer to it in the `ConvertSnippets` command)
    sources = {
      ultisnips = {
        -- ...or use absolute paths on your system.
        vim.fn.stdpath("config") .. "/snippets/ultisnips",
      },
    },
    output = {
      -- Specify the output formats and paths
      vscode_luasnip = {
        vim.fn.stdpath("config") .. "/snippets/vscode",
      },
    },
  }

  require("snippet_converter").setup({
    templates = { template },
    -- To change the default settings (see configuration section in the documentation)
    -- settings = {},
  })
end
