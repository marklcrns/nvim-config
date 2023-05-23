return function()
  require("vscode").setup({
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = vim.g.transparent_enable,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,
  })
end
