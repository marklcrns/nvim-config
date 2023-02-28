require("nvim-treesitter.configs").setup({
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  auto_install = true,
  -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,
    -- Disable latex and markdown in favor of vimtex's own parser
    disable = { "tex", "latex", "plaintex" }, -- list of language that will be disabled

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  -- Defined in nvim-treesitter-textobjects
  -- textobjects = {
  --   select = {
  --     enable = true,
  --     keymaps = {
  --       -- You can use the capture groups defined in textobjects.scm
  --       ["af"] = "@function.outer",
  --       ["if"] = "@function.inner",
  --       ["ac"] = "@class.outer",
  --       ["ic"] = "@class.inner",
  --     },
  --   },
  -- },

  -- vim-matchup configs
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
  },
})

vim.api.nvim_command("set foldmethod=expr")
vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")
